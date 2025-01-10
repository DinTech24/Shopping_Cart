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
            SELECT fldCategoryName,fldCategory_ID
            FROM tblCategory
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfreturn local.getcategoriesQuery>
    </cffunction>

    <cffunction  name="insertCategories" access="remote">
        <cfargument name="newCategory">
        <cfquery name="findSameCategory">
            SELECT fldcategoryName
            FROM tblCategory
            WHERE fldcategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfif queryRecordCount(findSameCategory)>
            <cfreturn true>
            <cfelse>
                <cfquery name="local.categoryInsertQuery">
                    INSERT INTO tblCategory(fldcategoryName,fldCreatedBy)
                    VALUES 
                        (
                            <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_varchar">
                        )
                </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="editCategory" access="remote">
        <cfargument  name="categoryId">
        <cfargument  name="newcategory">
        <cfquery name="findSameEditCategory">
            SELECT fldcategoryName
            FROM tblCategory
            WHERE fldcategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
                AND NOT fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfif queryRecordCount(findSameEditCategory)>
            <cfreturn true>
            <cfelse>
            <cfquery name="editCategoryQuery">
                UPDATE tblcategory
                SET fldCategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "cf_sql_varchar">
                WHERE fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_varchar">
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote">
        <cfargument  name="categoryId">
        <cfquery name="local.deleteCategoryQuery">
            UPDATE tblcategory
            SET fldActive = <cfqueryparam value = '0' cfsqltype = "cf_sql_varchar">
            WHERE fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_varchar">
        </cfquery>
    </cffunction>

    <cffunction  name="listSubcategories">
        <cfargument  name="categoryId">
        <cfquery name="local.getSubcategoryQuery">
            SELECT fldSubCategory_ID,fldSubCategoryName 
            FROM tblSubCategory 
            WHERE fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfreturn local.getSubcategoryQuery>
    </cffunction>

    <cffunction  name="addSubCategory" access="remote">
        <cfargument  name="categoryId">
        <cfargument name="newsubCategory">
        <cfquery name="findSameSubCategory">
            SELECT fldSubCategoryName
            FROM tblSubCategory
            WHERE fldSubCategoryName = <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfif queryRecordCount(findSameSubCategory)>
            <cfreturn true>
            <cfelse>
                <cfquery name="local.subCategoryInsertQuery">
                    INSERT INTO tblSubCategory(fldCategoryId,fldSubCategoryName,fldCreatedby)
                    VALUES 
                        (
                            <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "cf_sql_varchar">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_integer">
                        )
                </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="editSubCategoryFunction">
        <cfargument name="newSubCategory">
        <cfargument name="selectedCategory">
        <cfargument name="subCategoryId">
        <cfquery name="editSubcategoryQuery">
            UPDATE tblSubCategory
            SET fldSubCategoryName = <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "cf_sql_varchar">,
            fldCategoryId = <cfqueryparam value = '#arguments.selectedCategory#' cfsqltype = "cf_sql_integer">,
            fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_integer">,
            fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp">
            WHERE fldSubCategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction  name="deleteSubcategory" access="remote">
        <cfargument  name="subcategoryId">
        <cfquery name="local.deleteSubcategoryQuery">
            UPDATE tblSubCategory
            SET fldActive = <cfqueryparam value = '0' cfsqltype = "cf_sql_integer">,
            fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_integer">,
            fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp">
            WHERE fldSubCategory_ID = <cfqueryparam value = '#arguments.subcategoryId#' cfsqltype = "cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction name="adminLogout" access="remote">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>