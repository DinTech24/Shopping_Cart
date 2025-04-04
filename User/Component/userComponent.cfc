<cfcomponent>

    <cffunction  name="addUser" returnType="struct" description="Add user to Database">
        <cfargument  name="registerStructure" type="struct" required = "true">
        <cftry>
            <cfset local.exceptionStruct = structNew()>
            <cfset local.exceptionStruct["messageType"] = "Red">
            <cfset local.isUserExists = isUserExist(arguments.registerStructure.emailId,arguments.registerStructure.phonenumber)>
            <cfif trim(arguments.registerStructure.firstName) EQ "" OR
            trim(arguments.registerStructure.emailId) EQ "" OR
            trim(arguments.registerStructure.phonenumber) EQ "" OR
            trim(arguments.registerStructure.password) EQ "" >
                <cfset local.exceptionStruct["message"] = "Feilds cannot be empty">
                <cfreturn local.exceptionStruct>
            <cfelse>
                <cfset local.saltString = generateSecretKey("AES",128)>
                <cfset local.HashedPassword = hash(
                    "#arguments.registerStructure.password#"&"#local.saltString#",
                    "SHA-256",
                    "UTF-8"
                )>
                <cfif queryRecordCount(local.isUserExists)>
                    <cfset local.exceptionStruct["message"] = "User Already Exists">
                <cfelse>
                    <cfquery name="local.registerUserQuery">
                        INSERT INTO
                            tblUser(
                                fldFirstName,
                                fldLastName,
                                fldEmail,
                                fldPhone,
                                fldHashedPassword,
                                fldUserSaltString,
                                fldRoleId
                            )VALUES(
                                <cfqueryparam value = '#arguments.registerStructure.firstName#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#arguments.registerStructure.lastName#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#arguments.registerStructure.emailId#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#arguments.registerStructure.phonenumber#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#local.HashedPassword#' cfsqltype = "varchar">,
                                <cfqueryparam value = '#local.saltString#' cfsqltype = "varchar">,
                                1
                            )
                    </cfquery>
                    <cfset local.exceptionStruct["message"] = "User Successfully Added">
                    <cfset local.exceptionStruct["messageType"] = "green">
                </cfif>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn local.exceptionStruct>
    </cffunction>

    <cffunction  name="isUserExist" returnType="query" description="check user already exists">
        <cfargument  name="emailId" type="string" required = "false">
        <cfargument  name="phonenumber" type="string" required = "false">
        <cfargument  name="userId" type="numeric" required = "false">
        <cfargument  name="givenPassword" type="string" required = "false">
        <cfargument  name="enteredId" type="string" required="false">
        <cfquery name="local.getUserQuery">
            SELECT
                TOP 1
                fldFirstName,
                fldLastName, 
                fldEmail,
                fldPhone,
                fldUser_ID
            FROM
                tblUser 
            WHERE
                <cfif structKeyExists(arguments,"userId") AND structKeyExists(arguments,"emailId")>
                    NOT fldUser_ID = <cfqueryparam value = '#arguments.userId#' cfsqltype = "varchar">
                    AND(fldEmail = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">
                    OR fldPhone = <cfqueryparam value = '#arguments.phonenumber#' cfsqltype = "varchar">)
                <cfelseif structKeyExists(arguments,"userId")>
                    fldUser_ID = <cfqueryparam value = '#arguments.userId#' cfsqltype = "varchar">
                <cfelseif structKeyExists(arguments,"givenPassword")>
                    fldHashedPassword  = <cfqueryparam value = '#arguments.givenPassword#' cfsqltype = "varchar">
                    AND (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">
                    OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">)
                <cfelse>
                    (fldEmail = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">
                    OR fldPhone = <cfqueryparam value = '#arguments.phonenumber#' cfsqltype = "varchar">)
                </cfif>
                AND fldActive = 1
        </cfquery>
        <cfreturn local.getUserQuery>
    </cffunction>

    <cffunction  name="editUserProfile" returnType="boolean" returnFormat="JSON" access="remote" description="To edit user profile">
        <cfargument  name="userId" type="numeric" required = "true">
        <cfargument  name="userFirstName" type="string" required = "true">
        <cfargument  name="userLastName" type="string" required = "true">
        <cfargument  name="userEmail" type="string" required = "true">
        <cfargument  name="userPhone" type="string" required = "true">
        <cftry> 
            <cfif trim(arguments.userFirstName) EQ "" OR
            trim(arguments.userEmail) EQ "" OR
            trim(arguments.userPhone) EQ "">
            <cfelse>
                <cfset local.isUser = isUserExist(
                    userId = arguments.userId,
                    emailId = arguments.userEmail,
                    phonenumber = arguments.userPhone
                )>
                <cfif queryRecordCount(local.isUser) EQ 0>
                    <cfquery name="local.updateUser">
                        UPDATE
                            tblUser
                        SET
                            fldFirstName = <cfqueryparam value = '#arguments.userFirstName#' cfsqltype = "varchar">,
                            fldLastName = <cfqueryparam value = '#arguments.userLastName#' cfsqltype = "varchar">,
                            fldEmail = <cfqueryparam value = '#arguments.userEmail#' cfsqltype = "varchar">,
                            fldPhone = <cfqueryparam value = '#arguments.userPhone#' cfsqltype = "varchar">,
                            fldUpdatedBy = <cfqueryparam value = '#arguments.userId#' cfsqltype = "integer">,
                            fldUpdatedDate = <cfqueryparam value = '#Now()#' cfsqltype = "timestamp">
                        WHERE
                            flduser_ID = <cfqueryparam value = '#arguments.userId#' cfsqltype = "integer">
                    </cfquery>
                    <cfset session.username = arguments.userFirstName>
                    <cfset session.email = arguments.userEmail>
                    <cfreturn true>
                <cfelse>
                    <cfreturn false>
                </cfif>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getSecretKey" description = "To get the secret key from DB">
        <cfquery name="local.secretKeyQuery">
            SELECT
                fldSecretKey
            FROM
                tblAppConfiguration
        </cfquery>
        <cfreturn local.secretKeyQuery.fldSecretKey>
    </cffunction>

    <cffunction  name="loginUser" returnType="struct" access="remote" returnFormat="JSON"  description="Login user">
        <cfargument  name="enteredId" type="string" required = "true">
        <cfargument  name="enteredPassword" type="string" required = "true">
        <cfset local.loginExcepetion = structNew()>
        <cfif trim(arguments.enteredId) EQ "" OR trim(arguments.enteredPassword) EQ "">
            <cfset local.loginExcepetion["Message"] = "Empty Fields are not allowed!">
            <cfreturn local.loginExcepetion>
        </cfif>
        <cfquery name="local.checkPassword">
            SELECT 
                fldHashedPassword,
                fldUserSaltString 
            FROM
                tblUser 
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">
                OR fldPhone = <cfqueryparam value = '#arguments.enteredId#' cfsqltype = "varchar">)
        </cfquery>
        <cfif queryRecordCount(local.checkPassword)>
            <cfset local.givenPassword = hash(
                "#arguments.enteredPassword#"&"#local.checkPassword.fldUserSaltString#",
                "SHA-256",
                "UTF-8"
            )>
            <cfset local.checkUser = isUserExist(
                givenPassword = local.givenPassword,
                enteredId = arguments.enteredId
            )>
            <cfif queryRecordCount(local.checkUser)>
                <cfset session.userLogin = true>
                <cfset session.userId = local.checkUser.fldUser_ID>
                <cfset session.username = local.checkUser.fldFirstName>
                <cfset session.email = local.checkUser.fldEmail>
                <cfset cartData = displayCart()>
                <cfset session.productQuantity = queryRecordCount(cartData)>
                <cfset local.loginExcepetion["Message"] = true>
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
        <cfargument name="categoryId" type="numeric" required = "false">
        <cfargument name="allData" type="string" required = "false">
        <cfquery name="local.getCategoryQuery">
            SELECT 
                <cfif NOT structKeyExists(arguments, "allData")>
                    TOP 10
                </cfif>
                fldcategory_ID,
                fldcategoryName 
            FROM 
                tblCategory 
            WHERE 
                fldActive = 1
                <cfif structKeyExists(arguments, "categoryId")>
                    AND fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.getCategoryQuery>
    </cffunction>

    <cffunction name="listSubCategories" returnType="query" description="Get all sub-category details">
        <cfargument name="categoryId" type="numeric" required = "false">
        <cfargument name="subCategoryId" type="numeric" required="false">
        <cfquery name="local.getSubCategoryQuery">
            SELECT 
                fldsubCategory_ID,
                fldsubCategoryName,
                fldCategoryId,
                fldCategoryName
            FROM 
                tblSubCategory TS
                LEFT JOIN tblCategory TC ON TC.fldCategory_ID = TS.fldCategoryId 
            WHERE 
                TS.fldActive = 1
                AND TC.fldActive = 1
                <cfif structKeyExists(arguments, "subCategoryId")>
                    AND fldsubCategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "categoryId")>
                    AND fldcategoryId = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.getSubCategoryQuery>
    </cffunction>

    <cffunction name="getProducts" returnType="query" description="Get all products details">
        <cfargument name="sort" default="false" required = "false" type="string">
        <cfargument name="filterArray" required = "false">
        <cfargument name="subCategoryId" required = "false" type="numeric">
        <cfargument name="categoryId" required = "false" type="numeric">
        <cfargument name="productId" required = "false" type="numeric">
        <cfargument name="searchKeyword" required = "false" type="string">
        <cfargument name="offset" required = "false" type="integer">
        <cfargument name="productIdList" required = "false" type="string">
        <cfargument name="imageType" required = "false" type="string">
        <cfargument name="filterRange" required = "false" type="string">
        <cfif structKeyExists(arguments,"filterRange")>
            <cfif NOT arguments.filterRange EQ "invalid">
                <cfset local.filterArray = DeserializeJSON(arguments.filterRange)>
            </cfif>
        <cfelseif structKeyExists(arguments,"filterArray")>
            <cfset local.filterArray = arguments.filterArray>
        </cfif>
        <cftry>
            <cfquery name="local.getproductsQuery">
                SELECT 
                    <cfif arguments.sort EQ "false">
                        TOP 12
                    </cfif>
                    fldProduct_ID,
                    fldSubCategoryId,
                    fldSubCategoryName,
                    fldCategoryId,
                    fldCategoryName,
                    fldProductName,
                    fldDescription,
                    fldBrandId,
                    fldBrandName,
                    fldPrice,
                    fldTax,
                    fldImageFileName,
                    fldDefaultImage
                FROM 
                    tblProduct TP 
                INNER JOIN tblbrands TB ON TB.fldBrand_ID = TP.fldBrandId
                INNER JOIN tblProductImages TPI ON TPI.fldProductId = TP.fldProduct_ID
                INNER JOIN tblSubcategory TS ON TS.fldSubCategory_ID = TP.fldSubCategoryId
                INNER JOIN tblCategory TC ON TC.fldCategory_ID = TS.fldCategoryId
                WHERE
                    TP.fldActive = 1
                    AND TS.fldActive = 1
                    AND TC.fldActive = 1
                    <cfif NOT structKeyExists(arguments,"imageType")>
                        AND TPI.fldDefaultImage = 1
                    </cfif>
                    <cfif structKeyExists(arguments, "subCategoryId")>
                        AND fldSubCategoryId = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(local,"filterArray")>
                        AND fldPrice + (fldPrice*fldTax)/100 >=  <cfqueryparam value = '#val(local.filterArray[1])#' cfsqltype = "decimal">
                        AND fldPrice + (fldPrice*fldTax)/100 <=  <cfqueryparam value = '#val(local.filterArray[2])#' cfsqltype = "decimal">
                    <cfelseif structKeyExists(arguments, "productId")>
                        AND fldProduct_ID = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">;
                    <cfelseif structKeyExists(arguments, "searchKeyword")>
                        AND (fldProductName LIKE <cfqueryparam value = '%#trim(arguments.searchKeyword)#%' cfsqltype = "varchar">
                        OR fldBrandName LIKE <cfqueryparam value = '%#trim(arguments.searchKeyword)#%' cfsqltype = "varchar">
                        OR fldDescription LIKE <cfqueryparam value = '%#trim(arguments.searchKeyword)#%' cfsqltype = "varchar">)
                    <cfelseif structKeyExists(arguments, "categoryId")>
                        AND fldCategoryId = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                    <cfelse>
                        <cfif structKeyExists(arguments, "productIdList")>
                            AND fldProductId 
                            IN (<cfqueryparam value="#arguments.productIdList#" cfsqltype="integer" list="true">)
                        </cfif>
                        <cfif arguments.sort EQ "negative" OR arguments.sort EQ "false">
                            ORDER BY NEWID();
                        <cfelseif arguments.sort EQ "productSort">
                            ORDER BY fldProductId
                        <cfelse>
                            ORDER BY fldPrice + fldTax #arguments.sort#;
                        </cfif>
                        <cfif structKeyExists(arguments,"offset")>
                            OFFSET (#arguments.offset#-1) ROWS
                            FETCH NEXT 12 ROWS ONLY
                        </cfif>
                    </cfif>
                    <cfif structKeyExists(local,"filterArray")  AND arguments.sort NEQ "negative">
                        ORDER BY fldPrice + fldTax #arguments.sort#;
                    </cfif> 
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn local.getproductsQuery>
    </cffunction>

    <cffunction name="selectPriceRange" returnType="array" access="remote" returnFormat="JSON" description="Set price range for filtering products">
        <cfargument name="filterRange" required = "true">
        <cfargument  name="subCategoryId"  type="integer" required = "true">
        <cfset local.filterArray = DeserializeJSON(arguments.filterRange)>
        <cfset local.randomProductsRange = getProducts(
            sort="negative",
            filterArray= local.filterArray,
            subCategoryId=arguments.subCategoryId
        )>
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

    <cffunction name="addToCart"  returnType="void"  description="Add products to cart">
        <cfargument  name="productId" type="numeric" required = "true">
        <cftry>
            <cfset isProductInCart = displayCart(arguments.productId)>
            <cfif queryRecordCount(isProductInCart)>
                <cfset updateCartQuantity(
                    CartId = isProductInCart.fldCart_ID,
                    prQuantity = isProductInCart.fldQuantity + 1
                )>
            <cfelse>
                <cfset session.productQuantity = session.productQuantity + 1>
                <cfquery name="local.addToCartQuery">
                    INSERT INTO
                        tblCart(
                            fldUserId,
                            fldProductId,
                            fldQuantity
                        )VALUES(
                            <cfqueryparam value = '#session.userId#' cfsqltype = "integer">,
                            <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">,
                            1
                        )
                </cfquery>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="displayCart"  returnType="query"  description="Get all cart details">
        <cfargument  name="productId" type="numeric" required = "false">
        <cftry>
            <cfquery name="local.getCartQuery">
                SELECT
                    fldCart_ID,
                    fldQuantity,
                    fldProduct_ID,
                    fldSubCategoryId,
                    fldProductName,
                    fldBrandId,
                    fldBrandName,
                    fldPrice,
                    fldTax,
                    fldImageFileName
                FROM 
                    tblProduct TP
                INNER JOIN tblbrands TB ON TB.fldBrand_ID = TP.fldBrandId
                INNER JOIN tblProductImages TPI ON TPI.fldProductId = TP.fldProduct_ID
                INNER JOIN tblCart TC ON TC.fldProductId = TP.fldProduct_ID
                WHERE
                    fldUserId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                    AND TPI.fldDefaultImage = 1
                    AND TP.fldActive = 1
                    <cfif structKeyExists(arguments, "productId")>
                        AND TC.fldProductId = <cfqueryparam value = '#arguments.productId#' cfsqltype = "integer">
                    </cfif>
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn local.getCartQuery>
    </cffunction>

    <cffunction name="loadMoreData" returnType="array" returnFormat="JSON" access="remote">
        <cfargument name="productIdList" type="string" required="true">
        <cfargument  name="offsetValue" type="integer" required="true">
        <cfset local.resultProductQuery = getProducts(
            sort = "productSort",
            offset = arguments.offsetValue,
            productIdList = arguments.productIdList
        )>
        <cfset local.remainingProducts = []>
        <cfloop query="local.resultProductQuery">
            <cfset local.tempStruct = structNew()>
            <cfset local.tempStruct["fldProduct_ID"] = local.resultProductQuery.fldProduct_ID>
            <cfset local.tempStruct["fldSubCategoryId"] = local.resultProductQuery.fldSubCategoryId>
            <cfset local.tempStruct["fldProductName"] = local.resultProductQuery.fldProductName>
            <cfset local.tempStruct["fldDescription"] = local.resultProductQuery.fldDescription>
            <cfset local.tempStruct["fldBrandId"] = local.resultProductQuery.fldBrandId>
            <cfset local.tempStruct["fldBrandName"] = local.resultProductQuery.fldBrandName>
            <cfset local.tempStruct["fldPrice"] = local.resultProductQuery.fldPrice>
            <cfset local.tempStruct["fldTax"] = local.resultProductQuery.fldTax>
            <cfset local.tempStruct["fldImageFileName"] = local.resultProductQuery.fldImageFileName>
            <cfset arrayAppend(local.remainingProducts, local.tempStruct)>
        </cfloop>
        <cfreturn local.remainingProducts>
    </cffunction>

    <cffunction name="updateCartQuantity" access="remote" returnType="void"  description="Update product quantity in cart">
        <cfargument  name="CartId" type="numeric" required = "true">
        <cfargument  name="prQuantity" required = "true">
        <cftry>
            <cfif arguments.prQuantity LT 1>
                <cfset deleteCart(cartId = arguments.CartId)>
            <cfelse>
                <cfquery name="local.cartQuantityQuery">
                    UPDATE
                        tblCart
                    SET
                        fldQuantity = <cfqueryparam value = '#arguments.prQuantity#' cfsqltype = "integer">
                    WHERE
                        fldCart_ID = <cfqueryparam value = '#arguments.CartId#' cfsqltype = "integer">
                </cfquery>
            </cfif>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteCart" access="remote" returnType="void" description="Delete products from cart">
        <cfargument  name="CartId" type="numeric" required = "true">
        <cftry>
            <cfquery name="local.deleteCartQuery">
                DELETE FROM
                    tblCart
                WHERE 
                    fldCart_ID = <cfqueryparam value = '#arguments.CartId#' cfsqltype = "integer">
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
        <cfset session.productQuantity = session.productQuantity - 1>
    </cffunction>

    <cffunction name="validateAddress" returnType="boolean" description="Validate all fields in address modal">
        <cfargument  name="addressStructure" type="struct" required="true">
        <cfset local.flag = true>
        <cfif 
            trim(arguments.addressStructure.firstName) EQ ""
            OR trim(arguments.addressStructure.address1) EQ ""
            OR trim(arguments.addressStructure.city) EQ ""
            OR trim(arguments.addressStructure.state) EQ ""
            OR trim(arguments.addressStructure.pincode) EQ ""
            OR trim(arguments.addressStructure.phone) EQ ""
        >
            <cfset local.flag = false>
        </cfif>
        <cfset local.pincodePattern = "/^[0-9]{6}$/">
        <cfif reFind(local.pincodePattern,arguments.addressStructure.pincode)>
            <cfset local.flag = false>
        </cfif>
        <cfreturn local.flag>
    </cffunction>

    <cffunction  name="saveAddress" retrunType="void" description="Add new addresses">
        <cfargument  name="addressStructure" required="true" type="struct">
        <cftry>
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
                        )VALUES(
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
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="getSavedAddress" returnType="query"  description="Get all saved addresses">
        <cfquery name="local.getAddressQuery">
            SELECT
                fldAddress_ID,
                fldFirstName,
                fldLastName,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhoneNumber
            FROM
                tblAddress
            WHERE 
                fldUserId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                AND fldActive = 1
        </cfquery>
        <cfreturn local.getAddressQuery>
    </cffunction>

    <cffunction  name="deleteAddress" access="remote"  description="Deactivate addresses from database">
        <cfargument name="addressId" type="numeric">
        <cftry>
            <cfquery name="local.deleteAddressQuery">
                UPDATE
                    tblAddress
                SET
                    fldActive = 0
                WHERE
                    fldAddress_ID = <cfqueryparam value = '#arguments.addressId#' cfsqltype = "integer">
            </cfquery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="placeOrder" description="Function to place order" returnType="any">
        <cfargument name="orderStructure" type="struct">
        <cfargument  name="orderType" type="string">
        <cfset local.cardDetails = structNew()>
        <cfset local.cardDetails["cardNumber"] = "1111222233334444">
        <cfset local.cardDetails["cardMonth"] = "12">
        <cfset local.cardDetails["cardYear"] = "26">
        <cfset local.cardDetails["cardCvv"] = "000">
        <cfset local.cardPart = right(local.cardDetails["cardNumber"],4)>
        <cfset local.flag = true>
        <cfif arguments.orderStructure.cardNumberName NEQ local.cardDetails["cardNumber"]
            OR arguments.orderStructure.cardMonthName NEQ local.cardDetails["cardMonth"]
            OR arguments.orderStructure.cardYearName NEQ local.cardDetails["cardYear"]
            OR arguments.orderStructure.cardcvvName NEQ local.cardDetails["cardCvv"]
        >
            <cfset local.flag = false>
        </cfif>
        <cfif NOT structKeyExists(orderStructure, "addressSelect")>
            <cfset local.flag = false>
        </cfif>
        <cfif structKeyExists(arguments,"orderType")>
            <cfif NOT isNumeric(arguments.orderStructure.productQuantity)>
                <cfset local.flag = false>
            <cfelseif arguments.orderStructure.productQuantity LT 1>
                <cfset local.flag = false>
            </cfif>
        </cfif>
        <cfif local.flag EQ true>
            <cfset local.generatedUUID = createUUID()>
            <cfif structKeyExists(arguments, "orderType")>
                <cfset local.productResult = getProducts(
                    productId = arguments.orderStructure.productIdHidden
                )>
                <cfquery name="local.executeSPQuery">
                    EXEC
                    orderProduct_SP 
                        @userId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">,
                        @addressId = <cfqueryparam value = '#arguments.orderStructure.addressSelect#' cfsqltype = "integer">,
                        @generatedUuid = <cfqueryparam value = '#local.generatedUUID#' cfsqltype = "varchar">,
                        @cardPart = <cfqueryparam value = '#local.cardPart#' cfsqltype = "varchar">,
                        @orderType = <cfqueryparam value = 'BUY_NOW' cfsqltype = "varchar">,
                        @fldProductId = <cfqueryparam value = '#arguments.orderStructure.productIdHidden#' cfsqltype = "varchar">,
                        @fldQuantity = <cfqueryparam value = '#arguments.orderStructure.productQuantity#' cfsqltype = "varchar">,           
                        @fldPrice = <cfqueryparam value = '#local.productResult.fldPrice#' cfsqltype = "varchar">,    
                        @fldTax= <cfqueryparam value = '#local.productResult.fldTax#' cfsqltype = "varchar">       
                </cfquery>
            <cfelse>
                <cfif session.productQuantity NEQ 0>
                    <cfquery name="local.executeSPQuery">
                        EXEC
                        orderProduct_SP 
                            @userId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">,
                            @addressId = <cfqueryparam value = '#arguments.orderStructure.addressSelect#' cfsqltype = "integer">,
                            @generatedUuid = <cfqueryparam value = '#local.generatedUUID#' cfsqltype = "varchar">,
                            @cardPart = <cfqueryparam value = '#local.cardPart#' cfsqltype = "varchar">,
                            @orderType= <cfqueryparam value = 'FROM_CART' cfsqltype = "varchar">
                    </cfquery>
                    <cfset session.productQuantity = 0>
                <cfelse>
                    <cfset local.flag = false>
                </cfif>
            </cfif>
            <cfset orderConfirmationMail(local.generatedUUID)>
        </cfif>
        <cfreturn flag>
    </cffunction>

    <cffunction name="orderConfirmationMail" returnType="void" description="To send confirmation mail">
        <cfargument name="orderId" required="true" type="string">
        <cfset local.orderResult = displayOrderHistory(arguments.orderId)>
        <cfmail from="dinilvallikunnil@gmail.com"  subject="eCart Order Confirmation"  to="#session.email#">
            <cfmailpart type="text/html">
                <html>
                    <div>Hi, #session.username#<div>
                    <div>Your recent order through eCart is successfull.<div>
                    <div>Order Id : #arguments.orderId#<div>
                    <table border=1>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Tax</th>
                                <th>Amount</th>
                            </tr>
                        <thead>
                        <tbody>
                            <cfloop query="local.orderResult">
                                <tr>
                                    <td>#local.orderResult.fldProductName#</td>
                                    <td>#local.orderResult.fldQuantity#</td>
                                    <td>#local.orderResult.fldUnitPrice#</td>
                                    <td>#(local.orderResult.fldUnitTax * local.orderResult.fldUnitPrice)/100#</td>
                                    <td>#local.orderResult.fldQuantity*(local.orderResult.fldUnitTax * local.orderResult.fldUnitPrice)/100#</td>
                                </tr>
                            </cfloop>
                            <tr>
                                <td colspan="3">Total Price</td>
                                <td colspan="2">#local.orderResult.fldTotalPrice#</td>
                            </tr>
                            <tr>
                                <td colspan="3">Total Tax</td>
                                <td colspan="2">#local.orderResult.fldTotalTax#</td>
                            </tr>
                            <tr style="background-color:grey;color:white;">
                                <td colspan="3">Total Amount</td>
                                <td colspan="2">#local.orderResult.fldTotalPrice + local.orderResult.fldTotalTax#</td>
                            </tr>
                        </tbody>
                    </table>
                    <div>Thank you</div>
                </html>
            </cfmailpart>           
        </cfmail>
    </cffunction>

    <cffunction  name="displayOrderHistory" returnType="query" description = "To disaply Order History">
        <cfargument  name="orderId" required="false" type="string">
        <cfargument  name="pageNumber" required="false" type="string">
        <cfargument  name="orderSearch" required ="false" type="string">
        <cftry>
            <cfquery name="local.getOrderHistoryQuery">
                SELECT
                    fldProduct_ID,
                    fldSubCategoryId,
                    fldProductName,
                    fldBrandId,
                    fldBrandName,
                    fldUnitPrice,
                    fldUnitTax,
                    fldQuantity,
                    fldImageFileName,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhoneNumber,
                    fldOrder_ID,
                    fldOrderId,
                    fldTotalPrice,
                    fldTotalTax,
                    fldCardPart,
                    fldOrderDate
                FROM 
                    tblProduct TP
                INNER JOIN tblbrands TB ON TB.fldBrand_ID = TP.fldBrandId
                INNER JOIN tblProductImages TPI ON TPI.fldProductId = TP.fldProduct_ID
                INNER JOIN tblOrderedItems TOI ON TOI.fldProductId = TP.fldProduct_ID
                INNER JOIN tblOrder TOR ON TOR.fldOrder_ID = TOI.fldOrderId
                INNER JOIN tblAddress TA ON TA.fldAddress_ID = TOR.fldAddressId
                WHERE
                    TOR.fldUserId = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                    AND TPI.fldDefaultImage = 1
                    <cfif structKeyExists(arguments,"orderId")>
                        AND TOR.fldOrder_ID = <cfqueryparam value = '#arguments.orderId#' cfsqltype = "varchar">
                    </cfif>
                    <cfif structKeyExists(arguments,"orderSearch")>
                        AND (TOR.fldOrder_ID LIKE <cfqueryparam value = '%#arguments.orderSearch#%' cfsqltype = "varchar">
                        OR TP.fldProductName LIKE <cfqueryparam value = '%#arguments.orderSearch#%' cfsqltype = "varchar">)
                    </cfif>
                ORDER BY
                    fldOrderDate DESC
                    <cfif structKeyExists(arguments,"pageNumber")>
                        OFFSET (#(arguments.pageNumber * 10)-10#) ROWS
                        FETCH NEXT 10 ROWS ONLY
                    </cfif>
            </cfquery>
            <cfreturn local.getOrderHistoryQuery>
            <cfcatch>
                <cfset sendErrorMail(errorStruct = cfcatch)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="sendErrorMail">
        <cfargument name="errorStruct">
        <cfdump  var="#arguments.errorStruct#">
        <cfmail  from="dinilvallikunnil@gmail.com"  subject="Function Error"  to="diniladmin@gmail.com">
            <cfmailpart type="text/html">
                #arguments.errorStruct.Cause.Message#
                #arguments.errorStruct.Cause.NextException.TagContext[1].Raw_trace#
            </cfmailpart>
        </cfmail>
    </cffunction>

    <cffunction name="logoutUser" access="remote" returnType="void"  description="Logout user">
        <cfset structClear(session)>
    </cffunction>

</cfcomponent>