<cfcomponent>

    <cffunction  name="addUser">
        <cfargument  name="registerStructure">
        <cfset local.isUserExists = isUserExist(arguments.registerStructure.emailId,arguments.registerStructure.phonenumber)>
        <cfset local.saltString = generateSecretKey("AES",128)>
        <cfset local.HashedPassword = hash("#arguments.registerStructure.password#"&"#local.saltString#","SHA-256","UTF-8")>
        <cfif local.isUserExists>
            <cfreturn false>
            <cfelse>
                <cfquery name="registerUserQuery">
                    INSERT INTO
                        tblUser(fldFirstName,fldLastName,fldEmail,fldPhone,fldRoleId,fldHashedPassword,fldUserSaltString)
                    values(
                        <cfqueryparam value = '#arguments.registerStructure.firstName#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.registerStructure.lastName#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.registerStructure.emailId#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#arguments.registerStructure.phonenumber#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#local.HashedPassword#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#local.saltString#' cfsqltype = "cf_sql_varchar">
                    )
                </cfquery>
                <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction  name="isUserExist">
        <cfargument  name="emailId">
        <cfargument  name="phonenumber">
        <cfquery name="getUserQuery">
            SELECT
                fldEmail
            FROM
                tblUser 
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "cf_sql_varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.phonenumber#' cfsqltype = "cf_sql_varchar">)
                AND fldRoleId = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_integer">
        </cfquery>
        <cfif queryRecordCount(getUserQuery)>
            <cfreturn true>
            <cfelse>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="loginUser">
        <cfargument  name="enteredId">
        <cfargument  name="enteredPassword">
        <cfquery name="local.checkPassword">
            SELECT 
                fldHashedPassword ,fldUserSaltString 
            FROM
                tblUser 
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "cf_sql_varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "cf_sql_varchar">)
        </cfquery>
        <cfif queryRecordCount(local.checkPassword)>
            <cfset local.givenPassword =hash("#arguments.enteredPassword#"&"#local.checkPassword.fldUserSaltString#","SHA-256","UTF-8")>
            <cfquery name="local.checkUser">
                SELECT 
                    fldEmail
                FROM
                    tblUser 
                WHERE
                    (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "cf_sql_varchar">
                    OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "cf_sql_varchar">)
                    AND fldHashedPassword  = <cfqueryparam value = '#local.givenPassword#' cfsqltype = "cf_sql_varchar">
                    AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif queryRecordCount(local.checkUser)>
                <cfreturn true>
                <cfelse>
                    <cfreturn false>
            </cfif>
            <cfelse>
                <cfreturn false>
        </cfif>
    </cffunction>

</cfcomponent>