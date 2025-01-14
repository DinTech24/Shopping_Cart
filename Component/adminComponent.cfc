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
            SELECT 
                fldSubCategory_ID,fldSubCategoryName 
            FROM 
                tblSubCategory 
            WHERE 
                fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfreturn local.getSubcategoryQuery>
    </cffunction>
    
    <cffunction  name="listAllSubcategories" access="remote" returnFormat="JSON">
        <cfargument name="categoryId">
        <cfset subcateStructure = structNew()>
        <cfquery name="local.getSubcategoryQuery">
            SELECT 
                fldSubCategory_ID,fldSubCategoryName 
            FROM 
                tblSubCategory 
            WHERE 
                fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfloop query="local.getSubcategoryQuery">
            <cfset subcateStructure["#local.getSubcategoryQuery.fldSubCategory_ID#"] = "#local.getSubcategoryQuery.fldSubCategoryName #">
        </cfloop>
        <cfreturn subcateStructure>
    </cffunction>

    <cffunction name="getBrands">
        <cfquery name="getBrandQuery">
            SELECT 
                fldBrandName,fldBrand_ID
            FROM 
                tblbrands
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfreturn getBrandQuery>
    </cffunction>

    <cffunction  name="insertProduct">
        <cfargument  name="dataStructure">
        <cffile action="uploadall"
        destination="#expandPath('./Assets/ProductImages')#"
        result="local.productImages"
        nameconflict="makeunique">
        <cfset productResult = getProductCount(productname="#arguments.dataStructure.productname#",subcateid="#arguments.dataStructure.subcategoryname#")>
        <cfif queryRecordCount(productResult)>
            <cfreturn false>
            <cfelse>
            <cfquery name="insertProductQuery" result="generatedVal">
                INSERT INTO 
                    tblProduct(fldSubCategoryId,fldProductName,fldBrandId,fldDescription,fldPrice,fldTax,fldCreatedBy)
                VALUES(
                    <cfqueryparam value = '#arguments.dataStructure.subcategoryname#' cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = '#arguments.dataStructure.productname#' cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = '#arguments.dataStructure.brandname#' cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = '#arguments.dataStructure.descriptionname#' cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = '#arguments.dataStructure.pricename#' cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = '#arguments.dataStructure.taxname#' cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_varchar">
                )
            </cfquery>
            <cfset local.imagedefaultval = 1>
            <cfloop array="#local.productImages#" item="item">
                <cfquery name="insertImages">
                    INSERT INTO tblProductImages(fldProductId,fldImageFileName,fldDefaultImage,fldCreatedBy)
                    VALUES(
                        <cfqueryparam value = '#generatedVal.generatedKey#' cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = '#item.serverfile#' cfsqltype = "cf_sql_varchar">,
                        <cfqueryparam value = '#local.imagedefaultval#' cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_varchar">
                    )
                </cfquery>
                <cfset local.imagedefaultval = 0>
            </cfloop>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction  name="getProductCount">
        <cfargument name="productname">
        <cfargument  name="subcateid">
        <cfquery name="getProductQuery">
            SELECT 
                fldProduct_ID
            FROM
                tblProduct
            WHERE
                fldProductName = <cfqueryparam value = '#arguments.productname#' cfsqltype = "cf_sql_varchar">
                    AND fldSubCategoryId = <cfqueryparam value = '#arguments.subcateid#' cfsqltype = "cf_sql_integer">
                    AND fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_integer">
        </cfquery>
        <cfreturn getProductQuery>
    </cffunction>

    <cffunction  name="updateProduct">
        <cfargument  name="editDataStructure">
            <cfquery name="insertProductQuery" result="generatedVal">
                UPDATE tblProduct 
                SET fldSubCategoryId = <cfqueryparam value = '#arguments.editDataStructure.subcategoryname#' cfsqltype = "cf_sql_integer">,
                fldProductName = <cfqueryparam value = '#arguments.editDataStructure.productname#' cfsqltype = "cf_sql_varchar">,
                fldBrandId = <cfqueryparam value = '#arguments.editDataStructure.brandname#' cfsqltype = "cf_sql_integer">,
                fldDescription = <cfqueryparam value = '#arguments.editDataStructure.descriptionname#' cfsqltype = "cf_sql_varchar">,
                fldPrice = <cfqueryparam value = '#arguments.editDataStructure.pricename#' cfsqltype = "cf_sql_integer">,
                fldTax = <cfqueryparam value = '#arguments.editDataStructure.taxname#' cfsqltype = "cf_sql_integer">,
                fldupdatedBy = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_varchar">,
                fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp">
                WHERE 
                fldProduct_ID = <cfqueryparam value = '#arguments.editDataStructure.productEdit#' cfsqltype = "cf_sql_integer">
            </cfquery>
    </cffunction>

    <cffunction  name="getProducts" access="remote" returnFormat="JSON">
        <cfargument  name="subCategoryId">
        <cfargument  name="jscall" default=false>
        <cfargument  name="productId" default="">
        <cfset newStructure = structNew()>
        <cfquery name="local.getproductsQuery">
            SELECT fldProduct_ID,fldProductName,fldDescription,fldBrandId,fldBrandName,fldPrice,fldTax,fldImageFileName
            FROM tblProduct  
            LEFT JOIN tblbrands 
                ON tblbrands.fldBrand_ID = tblProduct.fldBrandId
            LEFT JOIN tblProductImages 
                ON tblProductImages.fldProductId = tblProduct.fldProduct_ID
            WHERE fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "cf_sql_varchar">
            AND fldDefaultImage = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
            AND tblProduct.fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
            AND tblbrands.fldActive = <cfqueryparam value = '1' cfsqltype = "cf_sql_varchar">
            <cfif arguments.jscall EQ true>
                AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "cf_sql_varchar">
            </cfif>
        </cfquery>
        <cfif arguments.jscall EQ true>
            <cfset newStructure["productid"] =local.getproductsQuery.fldProduct_ID>
            <cfset newStructure["productname"] =local.getproductsQuery.fldProductName>
            <cfset newStructure["productdesc"] =local.getproductsQuery.fldDescription>
            <cfset newStructure["brandid"] =local.getproductsQuery.fldBrandId>
            <cfset newStructure["productprice"] =local.getproductsQuery.fldPrice>
            <cfset newStructure["fldtax"] =local.getproductsQuery.fldTax>
            <cfset newStructure["fldimage"] =local.getproductsQuery.fldImageFileName>
             <cfreturn newStructure>
            <cfelse>
                <cfreturn local.getproductsQuery>
        </cfif>
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

    <cffunction  name="deleteproduct" access="remote">
        <cfargument  name="productId">
        <cfquery name="local.deleteSubcategoryQuery">
            UPDATE tblProduct
            SET fldActive = <cfqueryparam value = '0' cfsqltype = "cf_sql_integer">,
            fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "cf_sql_integer">,
            fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "cf_sql_timestamp">
            WHERE fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "cf_sql_integer">
        </cfquery>
    </cffunction>

    <cffunction  name="getProductImages" access="remote" returnFormat="JSON">
        <cfargument  name="productId">
        <cfset imageStructure = structNew()>
        <cfquery name="getProductImageQuery">
            SELECT 
                fldImageFileName,fldProductImage_ID,fldDefaultImage
            FROM 
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "cf_sql_integer">
        </cfquery>
        <cfloop query="getProductImageQuery">
            <cfset imageStructure[getProductImageQuery.fldProductImage_ID] = getProductImageQuery.fldImageFileName>
        </cfloop>
        <cfreturn imageStructure>
    </cffunction>

    <cffunction name="adminLogout" access="remote">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>