<!DOCTYPE html>
<html>
   <head>
        <title></title>
        <link href="./Bootstrap/bootstrap.min.css" rel="stylesheet">
        <link href="./CSS/userStyle.css" rel="stylesheet">
        <title>Product Page</title>
        <link rel="icon" type="image/x-icon" href="../Assets/SiteImages/LogoImage.png">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap" rel="stylesheet">
   </head>
   <cfoutput>
        <body>
            <cfinclude  template="./userHeader.cfm">
            <cfset variables.productObject = new Component.userComponent()>
            <cfset variables.resultProductDetails = variables.productObject.getRandomProducts(
                productId = url.productId,
                imageType = "all"
            )>
            <cfset variables.productsResult = variables.productObject.getRandomProducts(
                sort = "negative",
                subCategoryId = variables.resultProductDetails.fldSubCategoryId
            )>
            <cfset variables.encryptionString = variables.productObject.getSecretKey()>
            <cfset variables.randomLabels = [
                "Best Seller",
                "Special Price",
                "Best price ever",
                "Lightning deal",
                "Limited deal",
                "Get 5% off",
                "Get 10% off"
            ]>
            <div class="screenDivision d-flex ps-3 my-3">
                <div class="productImageDivision d-flex  justify-content-center">
                    <div>
                        <div id="carouselControls" class="carousel slide" data-bs-ride="carousel">
                            <div class="carousel-inner" id="carousel-inner">
                                <cfloop query="variables.resultProductDetails">
                                    <cfif variables.resultProductDetails.fldDefaultImage EQ 1>
                                        <div class="carousel-item active">
                                    <cfelse>
                                        <div class="carousel-item">
                                    </cfif>
                                        <img class="productAllImages1" src="../Assets/ProductImages/#variables.resultProductDetails.fldImageFileName#" alt="">
                                    </div>
                                </cfloop>
                            </div>
                            <button class="carousel-control-prev carousalcontro" type="button" data-bs-target="##carouselControls" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon btn btn-dark" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next carousalcontrol" type="button" data-bs-target="##carouselControls" data-bs-slide="next">
                                <span class="carousel-control-next-icon btn btn-dark" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                        <form method="POST">
                            <div class="buttonClassDivion">
                                <button class="screenDivisionButton1" name="addToCartButton">
                                    <i class="fa-solid fa-cart-shopping text-white "></i> 
                                    ADD TO CART
                                </button>
                                <button class="screenDivisionButton2" name="buyNowButton">
                                    <i class="fa-solid fa-bolt-lightning text-white"></i> 
                                    BUY NOW
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="screenSection2 ">
                    <div class="pathAndShare">
                        <div class="pageFullPath">
                            <a href="./userhomePage.cfm">Home</a>
                            <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            <a href="./categoriesListingPage.cfm?categoryId=#encodeForURL(encrypt(variables.resultProductDetails.fldcategoryId,variables.encryptionString,'AES','Base64'))#">#resultProductDetails.fldcategoryName#</a> 
                            <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            <a href="./subCategoriesListingPage.cfm?subCategoryId=#encodeForURL(encrypt(variables.resultProductDetails.fldsubCategoryId,variables.encryptionString,'AES','Base64'))#">#resultProductDetails.fldsubCategoryName# </a>
                            <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            <a class="text-primary">#variables.resultProductDetails.fldProductName#</a>
                        </div>
                    </div>
                    <div class="productName">#variables.resultProductDetails.fldProductName#</div>
                    <div class="productBrand">#variables.resultProductDetails.fldBrandName#</div>
                    <span class="specialPriceSpan">#variables.randomLabels[randRange(1, 7)]#</span>
                    
                    <div>
                        <div class="mt-1">
                            #variables.resultProductDetails.fldDescription#
                        </div>
                        <div class="productDiscountedPrice">
                            PRODUCT PRICE :
                            <span class="discountedPriceSpan">
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                #variables.resultProductDetails.fldPrice+(variables.resultProductDetails.fldTax * variables.resultProductDetails.fldPrice)/100#
                            </span>
                        </div>
                        <div class="mx-2 text-secondary fw-bold">#variables.resultProductDetails.fldTax#% Tax</div>
                    </div>
                    <div class="productImageMainDiv">
                        <cfloop query="variables.resultProductDetails" endRow="3">
                            <div class="me-3 productImageSubDiv">
                                <img class="productImagesSub" src="../Assets/ProductImages/#variables.resultProductDetails.fldImageFileName#" alt="Productimages">
                            </div>
                        </cfloop>
                    </div>
                </div>
            </div>
            <h3 class="m-3 mt-5">Related Products</h3>
            <div class="randomProductsMainDiv">
                <cfset variables.productsCount = 0>
                <cfloop query="variables.productsResult">
                    <cfif variables.productsResult.fldProduct_ID NEQ url.productId>
                        <cfset variables.productsCount = variables.productsCount + 1>
                        <div class="card randomProductCard" style="width: 13rem;">
                            <a class='text-decoration-none' href="./productPage.cfm?productId=#variables.productsResult.fldProduct_ID#">
                                <img src="../Assets/ProductImages/#variables.productsResult.fldImageFileName#" class="card-img-top randProductImage" alt="Product Image">
                                <div class="card-body randProductbody">
                                    <div class="card-text randProductName">#productsResult.fldProductName#</div>
                                    <div class="text-dark">#variables.productsResult.fldBrandName#</div>
                                    <div class="card-text randProductPrice">
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        #variables.productsResult.fldPrice + (variables.productsResult.fldTax * variables.productsResult.fldPrice)/100#
                                    </div>
                                </div>
                            </a>
                        </div>
                    </cfif>
                </cfloop>
            </div>
            <cfif variables.productsCount EQ 0>
                <div class="text-secondary ms-3">
                    No Related products to display
                </div>
            </cfif>
            <cfif structKeyExists(form, "addToCartButton")>
                <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                    <cfset variables.cartResult = productObject.addToCart(productId = url.productId)>
                    <cflocation  url="./userCartPage.cfm?productId=#url.productId#" addToken="no">
                <cfelse>
                    <cflocation  url="./userLogin.cfm?productId=#url.productId#" addToken="no">
                </cfif>
            </cfif>
            <cfif structKeyExists(form, "buyNowButton")>
                <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                    <cflocation url="./userOrderPage.cfm?productId=#url.productId#" addToken="no">
                <cfelse>
                    <cflocation url="./userLogin.cfm?productId=#url.productId#&buyNow=#true#" addToken="no">
                </cfif>
            </cfif>
            <cfinclude template="./footer.cfm">
            <script src="./Script/userPage.js"></script>
            <script src="../CommonScripts/validations.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        </body>
   </cfoutput>
</html>