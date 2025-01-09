<cfcomponent>

    <cffunction  name="adminLogin">
        <cfargument  name="adminUsername">
        <cfargument  name="adminPassword">
        <cfquery name="local.loginAdminQuery" datasource="myData">
            SELECT 
                fldFirstName,fldUser_ID,fldEmail,fldHashedPassword,fldUserSaltString
            FROM 
                tblUser
            LEFT JOIN 
                tblRole ON tblRole.fldRole_ID = tblUser.fldRoleId
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.adminUsername#' cfsqltype = "cf_sql_varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.adminUsername#' cfsqltype = "cf_sql_varchar">)
                AND tblRole.fldRoleName = <cfqueryparam value = 'admin' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfif queryRecordCount(local.loginAdminQuery)>
            <cfset local.enteredPassword ="#arguments.adminPassword#"&"#local.loginAdminQuery.fldUserSaltString#">
            <cfset local.hashedPassword = hash(local.enteredPassword,"sha-256","UTF-8")>
            <cfif local.loginAdminQuery.fldHashedPassword EQ local.hashedPassword>
                <cfset session.adminLogin = true>
                <cfset session.adminUserId = local.loginAdminQuery.fldUser_ID>
                <cfset session.username = local.loginAdminQuery.fldFirstName>
                <cfset session.email = local.loginAdminQuery.fldEmail>
                <cflocation  url="./adminHomePage.cfm">
                <cfelse>
                    <cfreturn false>
            </cfif>
            <cfelse>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="getCategories">
        <cfquery name="local.getcategoriesQuery">
            SELECT fldCategoryName
            FROM tblCategory
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfreturn local.getcategoriesQuery>
    </cffunction>

    <cffunction  name="insertCategories" access="remote">
        <cfargument name="newCategory">
        <cfquery name="local.categoryInsertQuery">
            INSERT INTO tblCategory(fldcategoryName,fldCreatedBy)
            VALUES 
                (
                    <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_varchar">
                )
        </cfquery>
    </cffunction>

    <cffunction name="adminLogout" access="remote">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>