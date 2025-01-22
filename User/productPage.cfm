<!DOCTYPE html>
<html>
   <head>
      <title></title>
      <link href="./Bootstrap/bootstrap.min.css" rel="stylesheet">
      <link href="./CSS/userStyle.css" rel="stylesheet">
      <title>Product Page</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
   </head>
   <cfoutput>
        <body>
            <cfinclude  template="./userHeader.cfm">
            <cfset productObject = new Component.userComponent()>
            <cfset resultProductDetails = productObject.getRandomProducts(productId = url.productId)>
            <cfset randomProductsResult = productObject.getRandomProducts(sort="negative")>
            <cfset resultProductImages = productObject.getProductImages(productId = url.productId)>
            <cfset subCategoryResult = productObject.listSubCategories(subCategoryId = resultProductDetails.fldSubCategoryId)>
            <cfset categoryResult = productObject.listCategories(categoryId = subCategoryResult.fldCategoryId)>
            <cfset randomLabels = [
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
                                <cfloop query="resultProductImages">
                                    <cfif resultProductImages.fldDefaultImage EQ 1>
                                        <div class="carousel-item active">
                                        <cfelse>
                                            <div class="carousel-item">
                                    </cfif>
                                        <img class="productAllImages1" src="../Assets/ProductImages/#resultProductImages.fldImageFileName#" alt="">
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
                        <div class="buttonClassDivion">
                            <button class="screenDivisionButton1"><i class="fa-solid fa-cart-shopping text-white "></i> ADD TO CART</button>
                            <button class="screenDivisionButton2 "><i class="fa-solid fa-bolt-lightning text-white"></i> BUY NOW</button>
                        </div>
                    </div>
                </div>
                <div class="screenSection2 ">
                    <div class="pathAndShare">
                        <div class="pageFullPath">
                            <a href="./userhomePage.cfm">Home</a>
                            <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            <a href="./categoriesListingPage.cfm?categoryId=#categoryResult.fldcategory_ID#">#categoryResult.fldcategoryName#</a> 
                            <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            <a href="./subCategoriesListingPage.cfm?subCategoryId=#subCategoryResult.fldsubCategory_ID#">#subCategoryResult.fldsubCategoryName# </a>
                            <i class="fa-solid fa-chevron-right fa-xs"></i> 
                            <a href="">#resultProductDetails.fldProductName#</a>
                        </div>
                    </div>
                    <div class="productName">#resultProductDetails.fldProductName#</div>
                    <div class="productBrand">#resultProductDetails.fldBrandName#</div>
                    <span class="specialPriceSpan">#randomLabels[randRange(1, 7)]#</span>
                    
                    <div>
                        <div class="mt-1">
                            #resultProductDetails.fldDescription#
                        </div>
                        <div class="productDiscountedPrice">
                            PRODUCT PRICE :
                            <span class="discountedPriceSpan">
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                #resultProductDetails.fldPrice+resultProductDetails.fldTax#
                            </span>
                        </div>
                    </div>
<!---                     <h5>Products's more images</h5> --->
                    <div class="productImageMainDiv">
                        <cfloop query="resultProductImages" endRow="3">
                            <div class="me-3 productImageSubDiv">
                                <img class="productImagesSub" src="../Assets/ProductImages/#resultProductImages.fldImageFileName#" alt="Productimages">
                            </div>
                        </cfloop>
                    </div>
                </div>
            </div>
            <h3 class="m-3 mt-5">Related Products</h3>
            <div class="randomProductsMainDiv">
                <cfloop query="randomProductsResult">
                    <cfif resultProductDetails.fldSubCategoryId EQ randomProductsResult.fldSubCategoryId 
                    AND randomProductsResult.fldProduct_ID NEQ url.productId>
                        <div class="card randomProductCard" style="width: 13rem;">
                            <a href="./productPage.cfm?productId=#randomProductsResult.fldProduct_ID#">
                                <img src="../Assets/ProductImages/#randomProductsResult.fldImageFileName#" class="card-img-top randProductImage" alt="Product Image">
                            </a>
                            <div class="card-body randProductbody">
                                <div class="card-text randProductName">#randomProductsResult.fldProductName#</div>
                                <div>#randomProductsResult.fldBrandName#</div>
                                <div class="card-text randProductPrice">
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    #randomProductsResult.fldPrice + randomProductsResult.fldTax#
                                </div>
                            </div>
                        </div>
                    </cfif>
                </cfloop>
            </div>
            <cfinclude template="./footer.cfm">
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        </body>
   </cfoutput>
</html>