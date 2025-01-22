<cfcomponent>

    <cffunction  name="addUser" returnType="struct">
        <cfargument  name="registerStructure" type="struct">
        <cfset local.exceptionStruct = structNew()>
        <cfset local.exceptionStruct["messageType"] = "Red">
        <cfset local.isUserExists = isUserExist(arguments.registerStructure.emailId,arguments.registerStructure.phonenumber)>
        <cfif trim(arguments.registerStructure.firstName) EQ "" OR
        trim(arguments.registerStructure.emailId) EQ "" OR
        trim(arguments.registerStructure.phonenumber) EQ "" OR
        trim(arguments.registerStructure.password) EQ "" >
            <cfset local.exceptionStruct["message"] = "Enter Data">
            <cfreturn local.exceptionStruct>
            <cfelse>
                <cfset local.saltString = generateSecretKey("AES",128)>
                <cfset local.HashedPassword = hash("#arguments.registerStructure.password#"&"#local.saltString#","SHA-256","UTF-8")>
                <cfif local.isUserExists>
                    <cfset local.exceptionStruct["message"] = "User Already Exists">
                    <cfelse>
                        <cfquery name="local.registerUserQuery">
                            INSERT INTO
                                tblUser(fldFirstName,fldLastName,fldEmail,fldPhone,fldRoleId,fldHashedPassword,fldUserSaltString)
                            values(
                                <cfqueryparam value = '#arguments.registerStructure.firstName#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#arguments.registerStructure.lastName#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#arguments.registerStructure.emailId#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#arguments.registerStructure.phonenumber#' cfsqltype = "varchar">,
                                <cfqueryparam value = '1' cfsqltype = "integer">,
                                <cfqueryparam value = '#local.HashedPassword#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#local.saltString#' cfsqltype = "varchar">
                            )
                        </cfquery>
                        <cfset local.exceptionStruct["message"] = "User Successfully Added">
                        <cfset local.exceptionStruct["messageType"] = "green">
                </cfif>
        </cfif>
        <cfreturn local.exceptionStruct>
    </cffunction>

    <cffunction  name="isUserExist" returnType="boolean">
        <cfargument  name="emailId" type="string">
        <cfargument  name="phonenumber" type="string">
        <cfquery name="local.getUserQuery">
            SELECT
                fldEmail
            FROM
                tblUser 
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.phonenumber#' cfsqltype = "varchar">)
                AND fldRoleId = <cfqueryparam value = '1' cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfif queryRecordCount(local.getUserQuery)>
            <cfreturn true>
            <cfelse>
                <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction  name="loginUser" returnType="struct" access="remote" returnFormat="JSON">
        <cfargument  name="enteredId" type="string">
        <cfargument  name="enteredPassword" type="string">
        <cfargument  name="jsCall" default = "false">
        <cfset local.loginExcepetion = structNew()>
        <cfif trim(arguments.enteredId) EQ "" OR trim(arguments.enteredPassword) EQ "">
            <cfset local.loginExcepetion["Message"] = "Empty Fields are not alllowed!">
            <cfreturn local.loginExcepetion>
        </cfif>
        <cfquery name="local.checkPassword">
            SELECT 
                fldHashedPassword ,fldUserSaltString 
            FROM
                tblUser 
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">)
        </cfquery>
        <cfif queryRecordCount(local.checkPassword)>
            <cfset local.givenPassword = hash("#arguments.enteredPassword#"&"#local.checkPassword.fldUserSaltString#","SHA-256","UTF-8")>
            <cfquery name="local.checkUser">
                SELECT 
                    fldUser_ID,fldFirstName,fldEmail
                FROM
                    tblUser 
                WHERE
                    (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">
                    OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">)
                    AND fldHashedPassword  = <cfqueryparam value = '#local.givenPassword#' cfsqltype = "varchar">
                    AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
            </cfquery>
            <cfif queryRecordCount(local.checkUser)>
                <cfset session.userLogin = true>
                <cfset session.userId = local.checkUser.fldUser_ID>
                <cfset session.username = local.checkUser.fldFirstName>
                <cfset session.email = local.checkUser.fldEmail>
                <cfif jscall EQ true>
                    <cfset local.loginExcepetion["Message"] = "true">
                    <cfelse>
                        <cflocation url="../User/userhomePage.cfm" addToken="no">
                </cfif>
                <cfelse>
                    <cfset local.loginExcepetion["Message"] = "Incorrect Password">
            </cfif>
            <cfelse>
                <cfset local.loginExcepetion["Message"] = "Enter a valid phoneNumber or emailId">
                <cfreturn local.loginExcepetion>
        </cfif>
        <cfreturn local.loginExcepetion>
    </cffunction>

    <cffunction  name="listCategories" returnType="query">
        <cfargument  name="categoryId" default=0 type="numeric">
        <cfquery name="local.getCategoryQuery">
            SELECT 
            <cfif structKeyExists(arguments, "categoryId")>
                TOP 9
            </cfif>
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
        <cfargument  name="categoryId" type="numeric">
        <cfargument  name="subCategoryId" type="numeric" required="false">
        <cfquery name="local.getSubCategoryQuery">
            SELECT 
                fldsubCategory_ID,fldsubCategoryName,fldCategoryId 
            FROM 
                tblSubCategory 
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                <cfif structKeyExists(arguments, "subCategoryId")>
                    AND fldsubCategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.getSubCategoryQuery>
    </cffunction>

    <cffunction  name="getRandomProducts" returnType="any">
        <cfargument  name="sort" default="false" required = "false">
        <cfargument  name="filterArray" default="false" required = "false">
        <cfargument  name="subCategoryId" default="false" required = "false">
        <cfargument  name="productId" required = "false">
        <cfargument  name="searchKeyword" required = "false">
        <cfquery name="local.getproductsQuery">
            SELECT 
                <cfif arguments.sort EQ "false">
                    TOP 12 
                </cfif>
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
                tblProductImages.fldDefaultImage = <cfqueryparam value = '1' cfsqltype = "integer">
                AND tblProduct.fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                <cfif IsArray(arguments.filterArray)>
                    AND fldPrice + fldTax >=  <cfqueryparam value = '#val(arguments.filterArray[1])#' cfsqltype = "decimal">
                    AND fldPrice + fldTax <=  <cfqueryparam value = '#val(arguments.filterArray[2])#' cfsqltype = "decimal">
                    AND fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">;
                    <cfelseif structKeyExists(arguments, "productId")>
                        AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">;
                    <cfelseif structKeyExists(arguments, "searchKeyword")>
                        AND (fldProductName LIKE <cfqueryparam value = '%#arguments.searchKeyword#%' cfsqltype = "varchar">
                        OR fldBrandName LIKE <cfqueryparam value = '%#arguments.searchKeyword#%' cfsqltype = "varchar">
                        OR fldDescription LIKE <cfqueryparam value = '%#arguments.searchKeyword#%' cfsqltype = "varchar">);
                    <cfelse>
                        <cfif arguments.sort EQ "false">
                            ORDER BY NEWID();
                            <cfelseif arguments.sort EQ "negative">
                                ;
                            <cfelse>
                                ORDER BY fldPrice + fldTax #arguments.sort#;
                        </cfif> 
                </cfif> 
        </cfquery>
        <cfreturn local.getproductsQuery>
    </cffunction>

    <cffunction  name="getProductImages" returnType="query">
        <cfargument  name="productId">
        <cfquery name="local.ProductImages">
            SELECT 
                fldImageFileName,
                fldDefaultImage
            FROM 
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
        </cfquery>
        <cfreturn local.ProductImages>
    </cffunction>

    <cffunction  name="selectPriceRange" access="remote" returnFormat="JSON">
        <cfargument name="filterRange">
        <cfargument  name="subCategoryId">
        <cfset local.filterArray = DeserializeJSON(arguments.filterRange)>
        <cfset local.randomProductsRange = getRandomProducts(sort=true,filterArray= local.filterArray,subCategoryId=arguments.subCategoryId)>
        <cfset local.rangeProductArray = []>
        <cfloop query="local.randomProductsRange">
            <cfset local.tempStruct = structNew()>
            <cfset local.tempStruct["fldProduct_ID"] = local.randomProductsRange.fldProduct_ID>
            <cfset local.tempStruct["fldSubCategoryId"] = local.randomProductsRange.fldSubCategoryId>
            <cfset local.tempStruct["fldProductName"] = local.randomProductsRange.fldProductName>
            <cfset local.tempStruct["fldDescription"] = local.randomProductsRange.fldDescription>
            <cfset local.tempStruct["fldBrandId"] = local.randomProductsRange.fldBrandId>
            <cfset local.tempStruct["fldBrandName"] = local.randomProductsRange.fldBrandName>
            <cfset local.tempStruct["fldPrice"] = local.randomProductsRange.fldPrice>
            <cfset local.tempStruct["fldTax"] = local.randomProductsRange.fldTax>
            <cfset local.tempStruct["fldImageFileName"] = local.randomProductsRange.fldImageFileName>
            <cfset arrayAppend(local.rangeProductArray, local.tempStruct)>
        </cfloop>
        <cfreturn local.rangeProductArray>
    </cffunction>

    <cffunction  name="logoutUser" access="remote" returnType="void">
        <cfset structClear(session)>
    </cffunction>

</cfcomponent>