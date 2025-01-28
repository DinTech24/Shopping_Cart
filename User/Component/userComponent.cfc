<cfcomponent>

    <cffunction  name="addUser" returnType="struct" description="Add user to Database">
        <cfargument  name="registerStructure" type="struct" required = "true">
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
                <cfif queryRecordCount(local.isUserExists)>
                    <cfset local.exceptionStruct["message"] = "User Already Exists">
                    <cfelse>
                        <cfquery name="local.registerUserQuery">
                            INSERT INTO
                                tblUser(fldFirstName,fldLastName,fldEmail,fldPhone,fldRoleId,fldHashedPassword,fldUserSaltString)
                            VALUES(
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

    <cffunction  name="isUserExist" returnType="query" description="check user already exists">
        <cfargument  name="emailId" type="string" required = "false">
        <cfargument  name="phonenumber" type="string" required = "false">
        <cfargument  name="userId" type="string" required = "false">
        <cfquery name="local.getUserQuery">
            SELECT
                fldFirstName,
                fldLastName, 
                fldEmail,
                fldPhone
            FROM
                tblUser 
            WHERE
                <cfif structKeyExists(arguments,"userId")>
                    fldUser_ID = <cfqueryparam value = '#arguments.userId#' cfsqltype = "varchar">
                    <cfelse>
                        (fldEmail = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">
                        OR fldPhone = <cfqueryparam value = '#arguments.phonenumber#' cfsqltype = "varchar">)
                </cfif>
                AND fldRoleId = <cfqueryparam value = '1' cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn local.getUserQuery>
    </cffunction>

    <cffunction  name="loginUser" returnType="struct" access="remote" returnFormat="JSON"  description="Login user">
        <cfargument  name="enteredId" type="string" required = "true">
        <cfargument  name="enteredPassword" type="string" required = "true">
        <cfargument  name="jsCall" default = "false" type="string" required = "true">
        <cfargument  name="productId" required="false" type="numeric">
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
                <cfset cartData = displayCart()>
                <cfset session.productQuantity = queryRecordCount(cartData)>
                <cfset session.username = local.checkUser.fldFirstName>
                <cfset session.email = local.checkUser.fldEmail>
                <cfif jscall EQ true>
                    <cfset local.loginExcepetion["Message"] = "true">
                    <cfelseif structKeyExists(arguments, "productId")>
                        <cflocation url="../User/userCartPage.cfm?productId=#arguments.productId#" addToken="no">
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

    <cffunction  name="listCategories" returnType="query" description="Get all category details">
        <cfargument  name="categoryId" type="numeric" required = "false">
        <cfargument  name="allData" type="string" required = "false">
        <cfquery name="local.getCategoryQuery">
            SELECT 
            <cfif NOT structKeyExists(arguments, "allData")>
                TOP 10
            </cfif>
                fldcategory_ID,fldcategoryName 
            FROM 
                tblCategory 
            WHERE 
                fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
                <cfif structKeyExists(arguments, "categoryId")>
                    AND fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.getCategoryQuery>
    </cffunction>

    <cffunction  name="listSubCategories" returnType="query" description="Get all sub-category details">
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

    <cffunction  name="getRandomProducts" returnType="any" description="Get all products details">
        <cfargument  name="sort" default="false" required = "false" type="string">
        <cfargument  name="filterArray" required = "false">
        <cfargument  name="subCategoryId" required = "false" type="numeric">
        <cfargument  name="productId" required = "false" type="numeric">
        <cfargument  name="searchKeyword" required = "false" type="string">
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
                <cfif structKeyExists(arguments, "filterArray")>
                    AND fldPrice + fldTax >=  <cfqueryparam value = '#val(arguments.filterArray[1])#' cfsqltype = "decimal">
                    AND fldPrice + fldTax <=  <cfqueryparam value = '#val(arguments.filterArray[2])#' cfsqltype = "decimal">
                    AND fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">;
                    <cfelseif structKeyExists(arguments, "productId")>
                        AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">;
                    <cfelseif structKeyExists(arguments, "searchKeyword")>
                        AND (fldProductName LIKE <cfqueryparam value = '%#trim(arguments.searchKeyword)#%' cfsqltype = "varchar">
                        OR fldBrandName LIKE <cfqueryparam value = '%#trim(arguments.searchKeyword)#%' cfsqltype = "varchar">
                        OR fldDescription LIKE <cfqueryparam value = '%#trim(arguments.searchKeyword)#%' cfsqltype = "varchar">);
                    <cfelse>
                        <cfif arguments.sort EQ "false">
                            ORDER BY NEWID();
                            <cfelseif arguments.sort EQ "negative">
                            ORDER BY NEWID();
                            <cfelseif arguments.sort EQ "positive">
                            ORDER BY fldProductId;
                            <cfelse>
                                ORDER BY fldPrice + fldTax #arguments.sort#;
                        </cfif> 
                </cfif> 
        </cfquery>
        <cfreturn local.getproductsQuery>
    </cffunction>

    <cffunction  name="getProductImages" returnType="query" description="Get images of products">
        <cfargument  name="productId" type="numeric" required = "true">
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

    <cffunction  name="selectPriceRange" access="remote" returnFormat="JSON" description="Set price range for filtering products">
        <cfargument name="filterRange" required = "true">
        <cfargument  name="subCategoryId"  type="numeric" required = "true">
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

    <cffunction  name="addToCart"  returnType="void"  description="Add products to cart">
        <cfargument  name="productId" type="numeric" required = "true">
        <cfset isProductInCart = displayCart(arguments.productId)>
        <cfif queryRecordCount(isProductInCart)>
            <cfset updateCartQuantity(
                CartId = isProductInCart.fldCart_ID,
                prQuantity = isProductInCart.fldQuantity + 1
            )>
            <cfelse>
                <cfset session.productQuantity = session.productQuantity + 1>
                <cfquery name="addToCartQuery">
                    INSERT INTO
                        tblCart(fldUserId,fldProductId,fldQuantity)
                    VALUES(
                        <cfqueryparam value = '#session.userId#' cfsqltype = "integer">,
                        <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">,
                        <cfqueryparam value = 1 cfsqltype = "integer">
                    )
                </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="displayCart"  returnType="query"  description="Get all cart details">
        <cfargument  name="productId" type="numeric" required = "false">
        <cfquery name="getCartQuery">
            SELECT
                fldCart_ID,
                fldProductId,
                fldQuantity
            FROM
                tblCart 
            WHERE
                fldUserId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                <cfif structKeyExists(arguments, "productId")>
                    AND fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn getCartQuery>
    </cffunction>

    <cffunction  name="updateCartQuantity" access="remote" returnType="void"  description="Update product quantity in cart">
        <cfargument  name="CartId" type="numeric" required = "true">
        <cfargument  name="prQuantity" required = "true">
        <cfif arguments.prQuantity EQ 0>
            <cfset deleteCart(cartId = arguments.CartId)>
            <cfelse>
                <cfquery name="cartQuantityQuery">
                    UPDATE
                        tblCart
                    SET
                        fldQuantity = <cfqueryparam value = '#arguments.prQuantity#' cfsqltype = "integer">
                    WHERE
                        fldCart_ID = <cfqueryparam value = '#arguments.CartId#' cfsqltype = "integer">
                </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="deleteCart" access="remote" returnType="void" description="Delete products from cart">
        <cfargument  name="CartId" type="numeric" required = "true">
        <cfquery name="deleteCartQuery">
            DELETE FROM
                tblCart
            WHERE 
                fldCart_ID = <cfqueryparam value = '#arguments.CartId#' cfsqltype = "integer">
        </cfquery>
        <cfset session.productQuantity = session.productQuantity - 1>
    </cffunction>

    <cffunction  name="validateAddress" returnType="boolean" description="Validate all fields in address modal">
        <cfargument  name="addressStructure" type="struct" required="true">
        <cfset flag = true>
        <cfset pincodePattern = "/^[0-9]{6}$/">
        <cfif 
            trim(arguments.addressStructure.firstName) EQ ""
            OR trim(arguments.addressStructure.address1) EQ ""
            OR trim(arguments.addressStructure.city) EQ ""
            OR trim(arguments.addressStructure.state) EQ ""
            OR trim(arguments.addressStructure.pincode) EQ ""
            OR trim(arguments.addressStructure.phone) EQ ""
        >
            <cfset flag = false>
        </cfif>
        <cfif NOT reFind(pincodePattern,'#arguments.addressStructure.pincode#')>
            <cfset flag = false>
        </cfif>
        <cfreturn flag>
    </cffunction>

    <cffunction  name="saveAddress" retrunType="void" description="Add new addresses">
        <cfargument  name="addressStructure" required="true" type="struct">
        <cfset isAddressValid = validateAddress(addressStructure = addressStructure)>
        <cfif isAddressValid>
            <cfquery name="local.addAddressQuery">
                INSERT INTO 
                    tblAddress(
                        fldUserId,
                        fldFirstName,
                        fldLastName,
                        fldAddressLine1,
                        fldAddressLine2,
                        fldCity,
                        fldState,
                        fldPincode,
                        fldPhoneNumber
                    )
                VALUES(
                    <cfqueryparam value = '#session.userId#' cfsqltype = "integer">,
                    <cfqueryparam value = '#arguments.addressStructure.firstName#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.lastName#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.address1#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.address2#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.city#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.state#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.pincode#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#arguments.addressStructure.phone#' cfsqltype = "varchar">
                )
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction  name="getSavedAddress" returnType="query"  description="Get all saved addresses">
        <cfquery name="local.getAddressQuery">
            SELECT
                fldAddress_ID,
                fldFirstName,
                fldLastName,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,fldState,
                fldPincode,
                fldPhoneNumber
            FROM
                tblAddress
            WHERE 
                fldUserId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = '1' cfsqltype = "integer">
        </cfquery>
        <cfreturn local.getAddressQuery>
    </cffunction>

    <cffunction  name="deleteAddress" access="remote"  description="Deactivate addresses from database">
        <cfargument name="addressId">
        <cfquery name="deleteAddressQuery">
            UPDATE
                tblAddress
            SET
                fldActive = <cfqueryparam value = '0' cfsqltype = "integer">
            WHERE
                fldAddress_ID = <cfqueryparam value = '#arguments.addressId#' cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction  name="logoutUser" access="remote" returnType="void"  description="Logout user">
        <cfset structClear(session)>
    </cffunction>

</cfcomponent>