<cfcomponent>

    <cffunction  name="adminLogin" returntype="struct">
        <cfargument  name="adminUsername">
        <cfargument  name="adminPassword">
        <cfset exceptionStruct = structNew()>
        <cfif trim(arguments.adminUsername) EQ "" OR trim(arguments.adminPassword)  EQ "">
            <cfset exceptionStruct["exception"] = "Enter all values to Proceed">
        </cfif>
        <cfquery name="local.loginAdminQuery" datasource="myData">
            SELECT 
                fldFirstName,
                fldUser_ID,
                fldEmail,
                fldHashedPassword,
                fldUserSaltString
            FROM 
                tblUser
            LEFT JOIN tblRole 
                ON tblRole.fldRole_ID = tblUser.fldRoleId
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
                    <cfset exceptionStruct["exception"] = "Entered Password is wrong">
            </cfif>
            <cfelse>
                <cfset exceptionStruct["exception"] = "Entered EmailId or PhoneNumber is wrong">
        </cfif>
        <cfreturn exceptionStruct>
    </cffunction>

    <cffunction  name="getCategories" returnType="query">
        <cfquery name="local.getcategoriesQuery">
            SELECT fldCategoryName,fldCategory_ID
            FROM tblCategory
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn local.getcategoriesQuery>
    </cffunction>

    <cffunction  name="insertCategories" access="remote" returnType="boolean" returnFormat="JSON">
        <cfargument name="newCategory">
        <cfquery name="local.findSameCategory">
            SELECT fldcategoryName
            FROM tblCategory
            WHERE fldcategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfif queryRecordCount(local.findSameCategory)>
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

    <cffunction  name="editCategory" access="remote" returnType="boolean" returnFormat="JSON">
        <cfargument  name="categoryId">
        <cfargument  name="newcategory">
        <cfquery name="findSameEditCategory">
            SELECT fldcategoryName
            FROM tblCategory
            WHERE fldcategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                AND NOT fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
        </cfquery>
        <cfif queryRecordCount(findSameEditCategory)>
            <cfreturn true>
            <cfelse>
                <cfquery name="editCategoryQuery">
                    UPDATE tblcategory
                    SET fldCategoryName = <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "varchar">
                    WHERE fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfquery>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returnType="void">
        <cfargument  name="categoryId">
        <cfquery name="local.deleteCategoryQuery">
            UPDATE tblcategory
            SET fldActive = <cfqueryparam value = '0' cfsqltype = "integer">
            WHERE fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="listSubcategories" returnType="query">
        <cfargument  name="categoryId">
        <cfquery name="local.getSubcategoryQuery">
            SELECT 
                fldSubCategory_ID,fldSubCategoryName 
            FROM 
                tblSubCategory 
            WHERE 
                fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn local.getSubcategoryQuery>
    </cffunction>
    
    <cffunction  name="listAllSubcategories" access="remote" returnFormat="JSON" returnType="struct">
        <cfargument name="categoryId">
        <cfset subcateStructure = structNew()>
        <cfquery name="local.getSubcategoryQuery">
            SELECT 
                fldSubCategory_ID,fldSubCategoryName 
            FROM 
                tblSubCategory 
            WHERE 
                fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfloop query="local.getSubcategoryQuery">
            <cfset subcateStructure["#local.getSubcategoryQuery.fldSubCategory_ID#"] = "#local.getSubcategoryQuery.fldSubCategoryName #">
        </cfloop>
        <cfreturn subcateStructure>
    </cffunction>

    <cffunction name="getBrands" returnType="query">
        <cfquery name="getBrandQuery">
            SELECT 
                fldBrandName,fldBrand_ID
            FROM 
                tblbrands
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn getBrandQuery>
    </cffunction>

    <cffunction  name="insertProduct" returnType="boolean">
        <cfargument  name="dataStructure">
        <cffile action="uploadall"
        destination="#expandPath('../Assets/ProductImages')#"
        result="local.productImages"
        nameconflict="makeunique">
        <cfset productResult = getProductCount(productname="#arguments.dataStructure.productname#",subcateid="#arguments.dataStructure.subcategoryname#")>
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
                        )
                VALUES(
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
                    INSERT INTO tblProductImages(fldProductId,fldImageFileName,fldDefaultImage,fldCreatedBy)
                    VALUES(
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

    <cffunction  name="getProductCount" returnType="query">
        <cfargument name="productname">
        <cfargument  name="subcateid">
        <cfquery name="getProductQuery">
            SELECT 
                fldProduct_ID
            FROM
                tblProduct
            WHERE
                fldProductName = <cfqueryparam value = '#arguments.productname#' cfsqltype = "varchar">
                    AND fldSubCategoryId = <cfqueryparam value = '#arguments.subcateid#' cfsqltype = "integer">
                    AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn getProductQuery>
    </cffunction>

    <cffunction  name="updateProduct" returnType="void">
        <cfargument  name="editDataStructure">
            <cfquery name="insertProductQuery" result="generatedVal">
                UPDATE tblProduct 
                SET fldSubCategoryId = <cfqueryparam value = '#arguments.editDataStructure.subcategoryname#' cfsqltype = "integer">,
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
            destination="#expandPath('./Assets/ProductImages')#"
            result="local.productImages"
            nameconflict="makeunique">
            <cfloop array="#local.productImages#" item="item">
                <cfquery name="insertImages">
                    INSERT INTO tblProductImages(fldProductId,fldImageFileName,fldCreatedBy)
                    VALUES(
                        <cfqueryparam value = '#arguments.editDataStructure.productEdit#' cfsqltype = "integer">,
                        <cfqueryparam value = '#item.serverfile#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                    )
                </cfquery>
            </cfloop>
    </cffunction>

    <cffunction  name="getProducts" access="remote" returnFormat="JSON" returnType="any">
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
            WHERE 
                fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                AND fldDefaultImage = <cfqueryparam value = '1' cfsqltype = "integer">
                AND tblProduct.fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                AND tblbrands.fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
            <cfif arguments.jscall EQ true>
                AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
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

    <cffunction  name="addSubCategory" access="remote" returnFormat="JSON" returnType="boolean">
        <cfargument  name="categoryId">
        <cfargument name="newsubCategory">
        <cfquery name="findSameSubCategory">
            SELECT fldSubCategoryName
            FROM tblSubCategory
            WHERE fldSubCategoryName = <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "varchar">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfif queryRecordCount(findSameSubCategory)>
            <cfreturn true>
            <cfelse>
                <cfquery name="local.subCategoryInsertQuery">
                    INSERT INTO tblSubCategory(fldCategoryId,fldSubCategoryName,fldCreatedby)
                    VALUES 
                        (
                            <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">,
                            <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                        )
                </cfquery>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="setDefaultImage" access="remote" returnType="void">
        <cfargument  name="imageId">
        <cfargument  name="productId">
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

    <cffunction  name="editSubCategoryFunction" returnType="void">
        <cfargument name="newSubCategory">
        <cfargument name="selectedCategory">
        <cfargument name="subCategoryId">
        <cfquery name="editSubcategoryQuery">
            UPDATE tblSubCategory
            SET fldSubCategoryName = <cfqueryparam value = '#arguments.newsubCategory#' cfsqltype = "varchar">,
            fldCategoryId = <cfqueryparam value = '#arguments.selectedCategory#' cfsqltype = "integer">,
            fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
            fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
            WHERE fldSubCategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="deleteSubcategory" access="remote" returnType="void">
        <cfargument  name="subcategoryId">
        <cfquery name="local.deleteSubcategoryQuery">
            UPDATE tblSubCategory
            SET fldActive = <cfqueryparam value = '0' cfsqltype = "integer">,
            fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
            fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
            WHERE fldSubCategory_ID = <cfqueryparam value = '#arguments.subcategoryId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="deleteproduct" access="remote" returnType="void">
        <cfargument  name="productId">
        <cfquery name="local.deleteSubcategoryQuery">
            UPDATE tblProduct
            SET fldActive = <cfqueryparam value = '0' cfsqltype = "integer">,
            fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
            fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
            WHERE fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="getProductImages" access="remote" returnFormat="JSON" returnType="struct">
        <cfargument  name="productId">
        <cfset imageStructure = structNew()>
        <cfset imageDefaultStruct = structNew()>
        <cfset imageinnerStruct = structNew()>
        <cfquery name="getProductImageQuery">
            SELECT 
                fldImageFileName,fldProductImage_ID,fldDefaultImage
            FROM 
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
        </cfquery>
        <cfloop query="getProductImageQuery">
            <cfif getProductImageQuery.fldDefaultImage EQ 1>
                <cfset imageStructure["imageDefaultStruct"][getProductImageQuery.fldProductImage_ID] = getProductImageQuery.fldImageFileName>
                <cfelse>
                    <cfset imageStructure["imageinnerStruct"][getProductImageQuery.fldProductImage_ID] = getProductImageQuery.fldImageFileName>
            </cfif>
        </cfloop>
        <cfreturn imageStructure>
    </cffunction>

    <cffunction  name="deleteProductImage" access="remote" returnType="void">
        <cfargument  name="imageId">
        <cfquery name="deleteImageQuery">
            DELETE
            FROM
                tblProductImages  
            WHERE
                fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction name="adminLogout" access="remote" returnType="void">
        <cfset structClear(session)>
    </cffunction>
    
</cfcomponent>