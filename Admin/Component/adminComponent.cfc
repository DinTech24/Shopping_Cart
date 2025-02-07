<cfcomponent>

    <cffunction name="adminLogin" returntype="struct" description="Function to login admin">
        <cfargument  name="adminUsername" type="string" required="true">
        <cfargument  name="adminPassword" type="string" required="true">
        <cfset local.exceptionStruct = structNew()>
        <cfif trim(arguments.adminUsername) EQ "" OR trim(arguments.adminPassword)  EQ "">
            <cfset local.exceptionStruct["exception"] = "Enter all values to Proceed">
        </cfif>
        <cfquery name="local.loginAdminQuery">
            SELECT 
                fldFirstName,
                fldUser_ID,
                fldEmail,
                fldHashedPassword,
                fldUserSaltString
            FROM 
                tblUser
            LEFT JOIN tblRole ON tblRole.fldRole_ID = tblUser.fldRoleId
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.adminUsername#' cfsqltype = "varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.adminUsername#' cfsqltype = "varchar">)
                AND tblRole.fldRoleName = <cfqueryparam value = 'admin' cfsqltype = "varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
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
                    <cfset local.exceptionStruct["exception"] = "Entered Password is wrong">
            </cfif>
            <cfelse>
                <cfset local.exceptionStruct["exception"] = "Entered EmailId or PhoneNumber is wrong">
        </cfif>
        <cfreturn local.exceptionStruct>
    </cffunction>

    <cffunction  name="getCategories" returnType="query" description="Function to get category details">
        <cfargument  name="categoryName" required="false">
        <cfargument  name="categoryId" required="false">
        <cfquery name="local.getcategoriesQuery">
            SELECT 
                fldCategoryName,
                fldCategory_ID
            FROM 
                tblCategory
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                <cfif structKeyExists(arguments, "categoryName")>
                    AND fldcategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">
                </cfif>
                <cfif structKeyExists(arguments, "categoryId")>
                    AND NOT fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfif>
            ORDER BY 
                fldCategoryName ASC;
        </cfquery>
        <cfreturn local.getcategoriesQuery>
    </cffunction>

    <cffunction  name="insertCategories" access="remote" returnType="boolean" returnFormat="JSON"  description="Function to insert Categories">
        <cfargument name="newcategory" type="string" required="true">
        <cfset local.findSameCategoryQuery = getCategories(categoryName = arguments.newcategory)>
        <cfif queryRecordCount(local.findSameCategoryQuery)>
            <cfreturn true>
            <cfelse>
                <cfquery name="local.categoryInsertQuery">
                    INSERT INTO tblCategory(fldcategoryName,fldCreatedBy)
                    VALUES 
                        (
                            <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                        )
                </cfquery>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="editCategory" access="remote" returnType="boolean" returnFormat="JSON"  description="Function to edit category">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfargument  name="newcategory" type="string" required="true">
        <cfset local.findSameCategoryQuery = getCategories(
            categoryName = arguments.newCategory,
            categoryId = arguments.categoryId
        )>
        <cfif queryRecordCount(local.findSameCategoryQuery)>
            <cfreturn true>
            <cfelse>
                <cfquery name="local.editCategoryQuery">
                    UPDATE 
                        tblcategory
                    SET 
                        fldCategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "varchar">
                    WHERE 
                        fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfquery>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returnType="void" description="Function to delete category">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfquery name="local.deleteCategoryQuery">
            UPDATE 
                tblcategory
            SET 
                fldActive = <cfqueryparam value = '0' cfsqltype = "integer">
            WHERE 
                fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction name="listSubcategories" access="remote" returnFormat="JSON" returnType="any" description="Function to get subcategory Details">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfargument  name="jscall" type="string" required="false">
        <cfargument  name="subCategoryName" type="string" required="false">
        <cfargument  name="subCategoryId" type="string" required="false">
        <cfquery name="local.getSubcategoryQuery">
            SELECT 
                fldSubCategory_ID,
                fldSubCategoryName 
            FROM 
                tblSubCategory 
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                <cfif structKeyExists(arguments,"subCategoryId")>
                    AND NOT fldSubCategory_ID =  <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "varchar">
                </cfif>
                <cfif structKeyExists(arguments,"subCategoryName")>
                    AND fldSubCategoryName =  <cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar">
                </cfif>
                AND fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
        </cfquery>
        <cfif structKeyExists(arguments, "jscall")>
            <cfset local.subcateStructure = structNew()>
            <cfloop query="local.getSubcategoryQuery">
                <cfset local.subcateStructure["#local.getSubcategoryQuery.fldSubCategory_ID#"] = "#local.getSubcategoryQuery.fldSubCategoryName #">
            </cfloop>
            <cfreturn local.subcateStructure>
            <cfelse>
                <cfreturn local.getSubcategoryQuery>
        </cfif>
    </cffunction>

    <cffunction name="getBrands" returnType="query" description="Function to get subcatBrandegory Details">
        <cfquery name="getBrandQuery">
            SELECT 
                fldBrandName,
                fldBrand_ID
            FROM 
                tblbrands
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn getBrandQuery>
    </cffunction>

    <cffunction  name="insertProduct" returnType="boolean" description="Function to insert product">
        <cfargument name="dataStructure" type="struct" required="true">
        <cffile action="uploadall"
        destination="#expandPath('../Assets/ProductImages')#"
        result="local.productImages"
        nameconflict="makeunique">
        <cfset productResult = getProducts(
            productName="#arguments.dataStructure.productname#",
            subCategoryId="#arguments.dataStructure.subcategoryname#"
        )>
        <cfif queryRecordCount(productResult)>
            <cfreturn false>
            <cfelse>
            <cfquery name="insertProductQuery" result="generatedVal">
                INSERT INTO 
                    tblProduct(
                        fldSubCategoryId,
                        fldProductName,
                        fldBrandId,
                        fldDescription,
                        fldPrice,
                        fldTax,
                        fldCreatedBy
                    )VALUES(
                        <cfqueryparam value = '#arguments.dataStructure.subcategoryname#' cfsqltype = "integer">,
                        <cfqueryparam value = '#arguments.dataStructure.productname#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.dataStructure.brandname#' cfsqltype = "integer">,
                        <cfqueryparam value = '#arguments.dataStructure.descriptionname#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.dataStructure.pricename#' scale="2" cfsqltype = "decimal">,
                        <cfqueryparam value = '#arguments.dataStructure.taxname#' scale="2" cfsqltype = "decimal">,
                        <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                    )
            </cfquery>
            <cfset local.imagedefaultval = 1>
            <cfloop array="#local.productImages#" item="item">
                <cfquery name="insertImages">
                    INSERT INTO 
                        tblProductImages(
                            fldProductId,
                            fldImageFileName,
                            fldDefaultImage,
                            fldCreatedBy
                        )VALUES(
                            <cfqueryparam value = '#generatedVal.generatedKey#' cfsqltype = "integer">,
                            <cfqueryparam value = '#item.serverfile#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#local.imagedefaultval#' cfsqltype = "integer">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                        )
                </cfquery>
                <cfset local.imagedefaultval = 0>
            </cfloop>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction  name="updateProduct" returnType="void"  description="Function to update products">
        <cfargument  name="editDataStructure"  type="struct" required="true">
        <cfquery name="insertProductQuery" result="generatedVal">
            UPDATE 
                tblProduct 
            SET 
                fldSubCategoryId = <cfqueryparam value = '#arguments.editDataStructure.subcategoryname#' cfsqltype = "integer">,
                fldProductName = <cfqueryparam value = '#arguments.editDataStructure.productname#' cfsqltype = "varchar">,
                fldBrandId = <cfqueryparam value = '#arguments.editDataStructure.brandname#' cfsqltype = "integer">,
                fldDescription = <cfqueryparam value = '#arguments.editDataStructure.descriptionname#' cfsqltype = "varchar">,
                fldPrice = <cfqueryparam value = '#arguments.editDataStructure.pricename#' scale="2" cfsqltype = "decimal">,
                fldTax = <cfqueryparam value = '#arguments.editDataStructure.taxname#' scale="2" cfsqltype = "decimal">,
                fldupdatedBy = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
                fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
            WHERE 
                fldProduct_ID = <cfqueryparam value = '#arguments.editDataStructure.productEdit#' cfsqltype = "integer">
        </cfquery>
        <cffile action="uploadall"
        destination="#expandPath('../Assets/ProductImages')#"
        result="local.productImages"
        nameconflict="makeunique">
        <cfloop array="#local.productImages#" item="item">
            <cfquery name="insertImages">
                INSERT INTO 
                    tblProductImages(
                        fldProductId,
                        fldImageFileName,
                        fldCreatedBy
                    )VALUES(
                        <cfqueryparam value = '#arguments.editDataStructure.productEdit#' cfsqltype = "integer">,
                        <cfqueryparam value = '#item.serverfile#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                    )
            </cfquery>
        </cfloop>
    </cffunction>

    <cffunction  name="getProducts" access="remote" returnFormat="JSON" returnType="any" description="Function to get product details">
        <cfargument name="subCategoryId" type="integer" required="false">
        <cfargument name="jscall"  required="false" type="boolean">
        <cfargument name="productId" type="integer">
        <cfargument name="productName" type="string">
        <cfset newStructure = structNew()>
        <cfquery name="local.getproductsQuery">
            SELECT 
                fldProduct_ID,
                fldProductName,
                fldDescription,
                fldBrandId,
                fldBrandName,
                fldPrice,
                fldTax,
                fldImageFileName
            FROM 
                tblProduct  
            LEFT JOIN tblbrands ON tblbrands.fldBrand_ID = tblProduct.fldBrandId
            LEFT JOIN tblProductImages ON tblProductImages.fldProductId = tblProduct.fldProduct_ID
            WHERE 
                fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                AND fldDefaultImage = <cfqueryparam value = '1' cfsqltype = "integer">
                AND tblProduct.fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                AND tblbrands.fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
            <cfif structKeyExists(arguments, "productName")>
                AND fldProductName = <cfqueryparam value = '#arguments.productName#' cfsqltype = "varchar">
            </cfif>
            <cfif structKeyExists(arguments, "jscall")>
                AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
            </cfif>
        </cfquery>
        <cfif structKeyExists(arguments, "jscall")>
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

    <cffunction  name="addSubCategory" access="remote" returnFormat="JSON" returnType="boolean" description="Function to add subcategory">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfargument name="newsubCategory" type="string" required="true">
        <cfset findSameSubCategory = listSubcategories(
            subCategoryName = arguments.newsubCategory,
            categoryId = arguments.categoryId
        )>
        <cfif queryRecordCount(findSameSubCategory)>
            <cfreturn false>
            <cfelse>
                <cfquery name="local.subCategoryInsertQuery">
                    INSERT INTO 
                        tblSubCategory(
                            fldCategoryId,
                            fldSubCategoryName,
                            fldCreatedby
                        )VALUES (
                            <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">,
                            <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                        )
                </cfquery>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="setDefaultImage" access="remote" returnType="void" description="Function to set Default Image of products">
        <cfargument  name="imageId" type="integer" required="true">
        <cfargument  name="productId" type="integer" required="true">
        <cfquery name="setDefaultImageQuery">
            UPDATE 
                tblProductImages
            SET
                fldDefaultImage = <cfqueryparam value = '1' cfsqltype = "integer">
            WHERE 
                fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">
        </cfquery>
        <cfquery name="unsetDefaultImageQuery">
            UPDATE 
                tblProductImages
            SET
                fldDefaultImage = <cfqueryparam value = '0' cfsqltype = "cf_sql_varchar">
            WHERE 
                NOT fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">
                AND fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="editSubCategoryFunction" returnType="boolean" description="Function to edit Subcategory">
        <cfargument name="newSubCategory" type="string" required="true">
        <cfargument name="selectedCategory" type="integer" required="true">
        <cfset findSameSubCategory = listSubcategories(
            subCategoryName = arguments.newsubCategory,
            categoryId = arguments.selectedCategory
        )>
        <cfif queryRecordCount(findSameSubCategory)>
            <cfreturn false>
            <cfelse>
                <cfquery name="editSubcategoryQuery">
                    UPDATE 
                        tblSubCategory
                    SET 
                        fldSubCategoryName = <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "varchar">,
                        fldCategoryId = <cfqueryparam value = '#arguments.selectedCategory#' cfsqltype = "integer">,
                        fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
                        fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
                    WHERE 
                        fldSubCategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                </cfquery>
                <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction  name="deleteSubcategory" access="remote" returnType="void"  description="Function to delete subcategory">
        <cfargument name="subcategoryId" type="integer" required="true">
        <cfquery name="local.deleteSubcategoryQuery">
            UPDATE 
                tblSubCategory
            SET 
                fldActive = <cfqueryparam value = '0' cfsqltype = "integer">,
                fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
                fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
            WHERE 
                fldSubCategory_ID = <cfqueryparam value = '#arguments.subcategoryId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="deleteproduct" access="remote" returnType="void"  description="Function to delete products">
        <cfargument  name="productId" type="integer" required="true">
        <cfquery name="local.deleteSubcategoryQuery">
            UPDATE 
                tblProduct
            SET 
                fldActive = <cfqueryparam value = '0' cfsqltype = "integer">,
                fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
                fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
            WHERE 
                fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="getProductImages" access="remote" returnFormat="JSON" returnType="struct" description="Function to get product Images">
        <cfargument  name="productId" type="integer" required="true">
        <cfset local.imageStructure = structNew()>
        <cfset local.imageDefaultStruct = structNew()>
        <cfset local.imageinnerStruct = structNew()>
        <cfquery name="local.getProductImageQuery">
            SELECT 
                fldImageFileName,
                fldProductImage_ID,
                fldDefaultImage
            FROM 
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
        </cfquery>
        <cfloop query="local.getProductImageQuery">
            <cfif local.getProductImageQuery.fldDefaultImage EQ 1>
                <cfset local.imageStructure["imageDefaultStruct"][local.getProductImageQuery.fldProductImage_ID] = local.getProductImageQuery.fldImageFileName>
                <cfelse>
                    <cfset local.imageStructure["imageinnerStruct"][local.getProductImageQuery.fldProductImage_ID] = local.getProductImageQuery.fldImageFileName>
            </cfif>
        </cfloop>
        <cfreturn imageStructure>
    </cffunction>

    <cffunction  name="deleteProductImage" access="remote" returnType="void"  description="Function to delete product images">
        <cfargument  name="imageId" type="integer" required="true">
        <cfquery name="deleteImageQuery">
            DELETE FROM
                tblProductImages  
            WHERE
                fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction name="adminLogout" access="remote" returnType="void"  description="Function to logout admin">
        <cfset structClear(session)>
    </cffunction>
    
</cfcomponent>