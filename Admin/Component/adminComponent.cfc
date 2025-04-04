<cfcomponent>

    <cffunction name="adminLogin" returntype="struct" description="Function to login admin">
        <cfargument  name="adminUsername" type="string" required="true">
        <cfargument  name="adminPassword" type="string" required="true">
        <cftry>
            <cfset local.exceptionStruct = structNew()>
            <cfset local.flag = true>
            <cfif trim(arguments.adminUsername) EQ "" OR trim(arguments.adminPassword)  EQ "">
                <cfset local.exceptionStruct["exception"] = "Enter all values to Proceed">
                <cfset local.flag = false>
            </cfif>
            <cfif local.flag>
                <cfquery name="local.loginAdminQuery">
                    SELECT
                        fldFirstName,
                        fldUser_ID,
                        fldEmail,
                        fldHashedPassword,
                        fldUserSaltString
                    FROM
                        tblUser TU
                    INNER JOIN tblRole TR ON TR.fldRole_ID = TU.fldRoleId
                    WHERE
                        (fldEmail = <cfqueryparam value = '#arguments.adminUsername#' cfsqltype = "varchar">
                        OR fldPhone = <cfqueryparam value = '#arguments.adminUsername#' cfsqltype = "varchar">)
                        AND TR.fldRoleName = <cfqueryparam value = 'admin' cfsqltype = "varchar">
                        AND fldActive = 1
                </cfquery>
                <cfif queryRecordCount(local.loginAdminQuery)>
                    <cfset local.enteredPassword ="#arguments.adminPassword#"&"#local.loginAdminQuery.fldUserSaltString#">
                    <cfset local.hashedPassword = hash(local.enteredPassword,"sha-256","UTF-8")>
                    <cfif local.loginAdminQuery.fldHashedPassword EQ local.hashedPassword>
                        <cfset session.adminLogin = true>
                        <cfset session.adminUserId = local.loginAdminQuery.fldUser_ID>
                        <cfset session.username = local.loginAdminQuery.fldFirstName>
                        <cfset session.email = local.loginAdminQuery.fldEmail>
                        <cfset local.exceptionStruct["exception"] = false>
                    <cfelse>
                        <cfset local.exceptionStruct["exception"] = "Entered Password is wrong">
                    </cfif>
                <cfelse>
                    <cfset local.exceptionStruct["exception"] = "Entered EmailId or PhoneNumber is wrong">
                </cfif>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn local.exceptionStruct>
    </cffunction>

    <cffunction name="getCategories" returnType="query" description="Function to get category details">
        <cfargument  name="categoryName" required="false">
        <cfargument  name="categoryId" required="false">
        <cfquery name="local.getcategoriesQuery">
            SELECT
                fldCategoryName,
                fldCategory_ID
            FROM
                tblCategory
            WHERE
                fldActive = 1
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

    <cffunction name="insertCategories" access="remote" returnType="boolean" returnFormat="JSON"  description="Function to insert Categories">
        <cfargument name="newcategory" type="string" required="true">
        <cftry>
            <cfset local.findSameCategoryQuery = getCategories(categoryName = arguments.newcategory)>
            <cfif queryRecordCount(local.findSameCategoryQuery)>
                <cfreturn true>
            <cfelse>
                <cfquery name="local.categoryInsertQuery">
                    INSERT INTO
                        tblCategory(
                            fldcategoryName,
                            fldCreatedBy
                        )VALUES(
                            <cfqueryparam value = '#arguments.newCategory#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                        )
                </cfquery>
            <cfreturn false>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="editCategory" access="remote" returnType="boolean" returnFormat="JSON"  description="Function to edit category">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfargument  name="newcategory" type="string" required="true">
        <cftry>
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
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returnType="void" description="Function to delete category">
        <cfargument  name="categoryId" type="integer" required="true">
        <cftry>
            <cfquery name="local.deleteCategoryQuery">
                UPDATE
                    tblcategory
                SET
                    fldActive = 0
                WHERE
                    fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="listSubcategories" access="remote" returnFormat="JSON" returnType="any" description="Function to get subcategory Details">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfargument  name="returnStruct" type="string" required="false">
        <cfargument  name="subCategoryName" type="string" required="false">
        <cfargument  name="subCategoryId" type="string" required="false">
        <cfquery name="local.getSubcategoryQuery">
            SELECT
                fldSubCategory_ID,
                fldSubCategoryName,
                fldCategoryName
            FROM
                tblSubCategory as TSC
            INNER JOIN  tblcategory AS TC ON TSC.fldCategoryId = TC.fldCategory_ID
            WHERE
                TSC.fldActive = 1
                AND TC.fldActive = 1
                <cfif structKeyExists(arguments,"subCategoryId")>
                    AND NOT fldSubCategory_ID =  <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "varchar">
                </cfif>
                <cfif structKeyExists(arguments,"subCategoryName")>
                    AND fldSubCategoryName =  <cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar">
                </cfif>
                AND fldCategoryId =  <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
        </cfquery>
        <cfif structKeyExists(arguments, "returnStruct")>
            <cfset local.subCategoryStructure = structNew()>
            <cfloop query="local.getSubcategoryQuery">
                <cfset local.subCategoryStructure["#local.getSubcategoryQuery.fldSubCategory_ID#"] = "#local.getSubcategoryQuery.fldSubCategoryName #">
            </cfloop>
            <cfreturn local.subCategoryStructure>
        <cfelse>
            <cfreturn local.getSubcategoryQuery>
        </cfif>
    </cffunction>

    <cffunction name="getBrands" returnType="query" description="Function to get subcatBrandegory Details">
        <cfquery name="local.getBrandQuery">
            SELECT
                fldBrandName,
                fldBrand_ID
            FROM
                tblbrands
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.getBrandQuery>
    </cffunction>

    <cffunction name="insertProduct" returnType="struct" description="Function to insert product">
        <cfargument name="dataStructure" type="struct" required="true">
        <cftry>
            <cfset local.exceptionStruct = structNew()>
            <cfset local.exceptionStruct["flag"] = true>
            <cfset productResult = getProducts(
                productName = arguments.dataStructure.productname,
                subCategoryId = arguments.dataStructure.subcategoryname
            )>
            <cfif trim(arguments.dataStructure.productname) EQ ""
                OR trim(arguments.dataStructure.brandname) EQ ""
                OR trim(arguments.dataStructure.descriptionname) EQ ""
                OR trim(arguments.dataStructure.pricename) EQ ""
                OR trim(arguments.dataStructure.taxname) EQ "">
                <cfset local.exceptionStruct["exception"] ="Empty fileds are not allowed">
                <cfset local.exceptionStruct["flag"] = false>
            <cfelseif arguments.dataStructure.taxname GT 100>
                <cfset local.exceptionStruct["exception"] ="Maximum tax allowed is 100%">
                <cfset local.exceptionStruct["flag"] = false>
            <cfelseif isNumeric(arguments.dataStructure.pricename) EQ false OR isNumeric(arguments.dataStructure.taxname) EQ false>
                <cfset local.exceptionStruct["exception"] ="Price and Tax should be numeric">
                <cfset local.exceptionStruct["flag"] = false>
            </cfif>
            <cfif local.exceptionStruct["flag"]>
                <cfif queryRecordCount(productResult)>
                    <cfset local.exceptionStruct["exception"] ="Cannot insert product with same name">
                    <cfset local.exceptionStruct["flag"] = false>
                    <cfelse>
                        <cfset local.exceptionStruct["flag"] = true>
                        <cfquery name="local.insertProductQuery" result="generatedVal">
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
                        <cffile action="uploadall"
                        destination="#expandPath('../Assets/ProductImages')#"
                        result="local.productImages"
                        nameconflict="makeunique">
                        <cfloop array="#local.productImages#" item="item" index="index">
                            <cfquery name="local.insertImages">
                                INSERT INTO 
                                    tblProductImages(
                                        fldProductId,
                                        fldImageFileName,
                                        fldDefaultImage,
                                        fldCreatedBy
                                    )VALUES(
                                        <cfqueryparam value = '#generatedVal.generatedKey#' cfsqltype = "integer">,
                                        <cfqueryparam value = '#item.serverfile#' cfsqltype = "varchar">,
                                        <cfif index EQ 1>
                                            1
                                        <cfelse>
                                            0
                                        </cfif>,
                                        <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">
                                    )
                            </cfquery>
                        </cfloop>
                </cfif>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn local.exceptionStruct>
    </cffunction>

    <cffunction name="updateProduct" returnType="struct" description="Function to update products">
        <cfargument name="editDataStructure" type="struct" required="true">
        <cftry>
            <cfset local.exceptionStruct = structNew()>
            <cfset local.exceptionStruct["flag"] = true>
            <cfif trim(arguments.editDataStructure.productname) EQ ""
                OR trim(arguments.editDataStructure.brandname) EQ ""
                OR trim(arguments.editDataStructure.descriptionname) EQ ""
                OR trim(arguments.editDataStructure.pricename) EQ ""
                OR trim(arguments.editDataStructure.taxname) EQ "">
                <cfset local.exceptionStruct["exception"] ="Empty fileds are not allowed">
                <cfset local.exceptionStruct["flag"] = false>
            <cfelseif arguments.editDataStructure.taxname GT 100>
                <cfset local.exceptionStruct["exception"] ="Maximum tax allowed is 100%">
                <cfset local.exceptionStruct["flag"] = false>
            <cfelseif isNumeric(arguments.editDataStructure.pricename) EQ false OR isNumeric(arguments.editDataStructure.taxname) EQ false>
                <cfset local.exceptionStruct["exception"] ="Price and Tax should be numeric">
                <cfset local.exceptionStruct["flag"] = false>
            </cfif>
            <cfif local.exceptionStruct["flag"] EQ true>
                <cfquery name="local.insertProductQuery" result="generatedVal">
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
                    <cfquery name="local.insertImages">
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
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn local.exceptionStruct>
    </cffunction>

    <cffunction name="getProducts" access="remote" returnFormat="JSON" returnType="any" description="Function to get product details">
        <cfargument name="subCategoryId" type="integer" required="true">
        <cfargument name="returnStruct"  required="false" type="boolean">
        <cfargument name="productId" type="integer" required="false">
        <cfargument name="productName" type="string" required="false">
        <cftry>
            <cfset local.newStructure = structNew()>
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
                    tblProduct TP
                LEFT JOIN tblbrands TB ON TB.fldBrand_ID = TP.fldBrandId
                LEFT JOIN tblProductImages TPI ON TPI.fldProductId = TP.fldProduct_ID
                WHERE 
                    fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                    AND fldDefaultImage = 1
                    AND TP.fldActive = 1
                    AND TB.fldActive = 1
                    <cfif structKeyExists(arguments, "productName")>
                        AND fldProductName = <cfqueryparam value = '#arguments.productName#' cfsqltype = "varchar">
                    </cfif>
                    <cfif structKeyExists(arguments, "returnStruct")>
                        AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
                    </cfif>
            </cfquery>
            <cfif structKeyExists(arguments, "returnStruct")>
                <cfset local.newStructure["productid"] = local.getproductsQuery.fldProduct_ID>
                <cfset local.newStructure["productname"] = local.getproductsQuery.fldProductName>
                <cfset local.newStructure["productdesc"] = local.getproductsQuery.fldDescription>
                <cfset local.newStructure["brandid"] = local.getproductsQuery.fldBrandId>
                <cfset local.newStructure["productprice"] = local.getproductsQuery.fldPrice>
                <cfset local.newStructure["fldtax"] = local.getproductsQuery.fldTax>
                <cfset local.newStructure["fldimage"] = local.getproductsQuery.fldImageFileName>
                <cfreturn local.newStructure>
                <cfelse>
                    <cfreturn local.getproductsQuery>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addSubCategory" access="remote" returnFormat="JSON" returnType="boolean" description="Function to add subcategory">
        <cfargument  name="categoryId" type="integer" required="true">
        <cfargument name="newsubCategory" type="string" required="true">
        <cftry>
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
                <cfreturn true>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="setDefaultImage" access="remote" returnType="void" description="Function to set Default Image of products">
        <cfargument  name="imageId" type="integer" required="true">
        <cfargument  name="productId" type="integer" required="true">
        <cftry>
            <cfquery name="local.setDefaultImageQuery">
                UPDATE 
                    tblProductImages
                SET
                    fldDefaultImage = 1
                WHERE 
                    fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">
            </cfquery>
            <cfquery name="local.unsetDefaultImageQuery">
                UPDATE 
                    tblProductImages
                SET
                    fldDefaultImage = <cfqueryparam value = '0' cfsqltype = "cf_sql_varchar">
                WHERE 
                    NOT fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">
                    AND fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="editSubCategoryFunction" returnType="boolean" description="Function to edit Subcategory">
        <cfargument name="newSubCategory" type="string" required="true">
        <cfargument name="selectedCategory" type="integer" required="true">
        <cfargument  name="subCategoryId" type="integer" required="true">
        <cftry>
            <cfset findSameSubCategory = listSubcategories(
                subCategoryName = arguments.newsubCategory,
                categoryId = arguments.selectedCategory,
                subCategoryId = arguments.subCategoryId
            )>
            <cfif queryRecordCount(findSameSubCategory)>
                <cfreturn false>
            <cfelse>
                <cfquery name="local.editSubcategoryQuery">
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
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteSubcategory" access="remote" returnType="void"  description="Function to delete subcategory">
        <cfargument name="subcategoryId" type="integer" required="true">
        <cftry>
            <cfquery name="local.deleteSubcategoryQuery">
                UPDATE
                    tblSubCategory
                SET
                    fldActive = 0,
                    fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
                    fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
                WHERE
                    fldSubCategory_ID = <cfqueryparam value = '#arguments.subcategoryId#' cfsqltype = "integer">
            </cfquery>
            <cfset deleteproduct(subcategoryId = arguments.subcategoryId)>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteproduct" access="remote" returnType="void"  description="Function to delete products">
        <cfargument name="productId" type="integer" required="false">
        <cfargument  name="subcategoryId" type="integer" required="false">
        <cftry>
            <cfquery name="local.deleteSubcategoryQuery">
                UPDATE
                    tblProduct
                SET
                    fldActive = 0,
                    fldupdatedby = <cfqueryparam value = '#session.adminUserId#' cfsqltype = "integer">,
                    fldUpdatedDate = <cfqueryparam value = '#now()#' cfsqltype = "timestamp">
                WHERE
                    <cfif structKeyExists(arguments,"productId")>
                        fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
                        <cfelse>
                            fldSubcategoryId = <cfqueryparam value = '#arguments.subcategoryId#' cfsqltype = "integer">
                    </cfif>
            </cfquery>
            <cfif structKeyExists(arguments,"productId")>
                <cfset deleteProductImage(productId = arguments.productId)>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getProductImages" access="remote" returnFormat="JSON" returnType="struct" description="Function to get product Images">
        <cfargument name="productId" type="integer" required="true">
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
        <cfargument  name="imageId" type="integer" required="false">
        <cfargument  name="productId" type="integer" required="false">
        <cftry>
            <cfquery name="local.deleteImageQuery">
                DELETE FROM
                    tblProductImages
                WHERE
                    <cfif structKeyExists(arguments,"productId")>
                        fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
                        AND fldDefaultImage = 0;
                    <cfelse>
                        fldProductImage_ID = <cfqueryparam value = '#arguments.imageId#' cfsqltype = "integer">;
                    </cfif>
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="sendErrorMail">
        <cfargument name="errorStruct">
        <cfdump  var="#arguments.errorStruct#">
        <cfmail  from="dinilvallikunnil@gmail.com"  subject="Function Error"  to="diniladmin@gmail.com">
            <cfmailpart type="text/html">
                #arguments.errorStruct.Cause.Message#
                #arguments.errorStruct.Cause.NextException.TagContext[1].Raw_trace#
            </cfmailpart>
        </cfmail>
    </cffunction>

    <cffunction name="adminLogout" access="remote" returnType="void"  description="Function to logout admin">
        <cfset structClear(session)>
    </cffunction>
    
</cfcomponent>