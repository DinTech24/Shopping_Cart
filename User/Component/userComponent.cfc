<cfcomponent>

    <cffunction  name="addUser" returnType="struct">
        <cfargument  name="registerStructure">
        <cfset exceptionStruct = structNew()>
        <cfset exceptionStruct["messageType"] = "Red">
        <cfset local.isUserExists = isUserExist(arguments.registerStructure.emailId,arguments.registerStructure.phonenumber)>
        <cfif trim(arguments.registerStructure.firstName) EQ "" OR
        trim(arguments.registerStructure.emailId) EQ "" OR
        trim(arguments.registerStructure.phonenumber) EQ "" OR
        trim(arguments.registerStructure.password) EQ "" >
            <cfset exceptionStruct["message"] = "Enter Data">
            <cfreturn exceptionStruct>
            <cfelse>
                <cfset local.saltString = generateSecretKey("AES",128)>
                <cfset local.HashedPassword = hash("#arguments.registerStructure.password#"&"#local.saltString#","SHA-256","UTF-8")>
                <cfif local.isUserExists>
                    <cfset exceptionStruct["message"] = "User Already Exists">
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
                        <cfset exceptionStruct["message"] = "User Successfully Added">
                        <cfset exceptionStruct["messageType"] = "green">
                </cfif>
        </cfif>
        <cfreturn exceptionStruct>
    </cffunction>

    <cffunction  name="isUserExist" returnType="boolean">
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

    <cffunction  name="loginUser" returnType="struct" access="remote" returnFormat="JSON">
        <cfargument  name="enteredId">
        <cfargument  name="enteredPassword">
        <cfargument  name="jsCall" default = "false">
        <cfset loginExcepetion = structNew()>
        <cfif trim(arguments.enteredId) EQ "" OR trim(arguments.enteredPassword) EQ "">
            <cfset loginExcepetion["Message"] = "Empty Fields are not alllowed!">
            <cfreturn loginExcepetion>
        </cfif>
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
            <cfset local.givenPassword = hash("#arguments.enteredPassword#"&"#local.checkPassword.fldUserSaltString#","SHA-256","UTF-8")>
            <cfquery name="local.checkUser">
                SELECT 
                    fldUser_ID,fldFirstName,fldEmail
                FROM
                    tblUser 
                WHERE
                    (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "cf_sql_varchar">
                    OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "cf_sql_varchar">)
                    AND fldHashedPassword  = <cfqueryparam value = '#local.givenPassword#' cfsqltype = "cf_sql_varchar">
                    AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif queryRecordCount(local.checkUser)>
                <cfset session.userLogin = true>
                <cfset session.userId = local.checkUser.fldUser_ID>
                <cfset session.username = local.checkUser.fldFirstName>
                <cfset session.email = local.checkUser.fldEmail>
                <cfif jscall EQ true>
                    <cfset loginExcepetion["Message"] = "true">
                    <cfelse>
                        <cflocation url="../User/userhomePage.cfm" addToken="no">
                </cfif>
                <cfelse>
                    <cfset loginExcepetion["Message"] = "Incorrect Password">
            </cfif>
            <cfelse>
                <cfset loginExcepetion["Message"] = "Enter a valid phoneNumber or emailId">
                <cfreturn loginExcepetion>
        </cfif>
        <cfreturn loginExcepetion>
    </cffunction>

    <cffunction  name="listCategories" returnType="query">
        <cfargument  name="categoryId" default = 0>
        <cfquery name="local.getCategoryQuery">
            SELECT TOP 9
                fldcategory_ID,fldcategoryName 
            FROM 
                tblCategory 
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                <cfif arguments.categoryId NEQ 0>
                    AND fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.getCategoryQuery>
    </cffunction>

    <cffunction  name="listSubCategories" returnType="query">
        <cfargument  name="categoryId">
        <cfquery name="local.getSubCategoryQuery">
            SELECT 
                fldsubCategory_ID,fldsubCategoryName,fldCategoryId 
            FROM 
                tblSubCategory 
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn local.getSubCategoryQuery>
    </cffunction>

    <cffunction  name="getRandomProducts" access="remote" returnFormat="JSON" returnType="any">
        <cfquery name="local.getproductsQuery">
            SELECT TOP 12 
                fldProduct_ID,
                fldSubCategoryId,
                fldProductName,
                fldDescription,
                fldBrandId,
                fldBrandName,
                fldPrice,
                fldTax,
                fldImageFileName
            FROM 
                tblProduct  
            LEFT JOIN 
                tblbrands 
                ON tblbrands.fldBrand_ID = tblProduct.fldBrandId
            LEFT JOIN 
                tblProductImages 
                ON tblProductImages.fldProductId = tblProduct.fldProduct_ID
            WHERE 
                tblProductImages.fldDefaultImage = 1
                AND tblProduct.fldActive = 1
            ORDER BY 
                NEWID();
        </cfquery>
        <cfreturn local.getproductsQuery>
    </cffunction>

    <cffunction  name="logoutUser" access="remote" returnType="void">
        <cfset structClear(session)>
    </cffunction>

</cfcomponent>