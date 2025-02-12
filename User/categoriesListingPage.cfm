<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Home Page</title>
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="icon" type="image/x-icon" href="../Assets/SiteImages/LogoImage.png">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap" rel="stylesheet">
    </head>
    <body class="hideScroll">
        <cfoutput>
            <cfset variables.userCateObject = new Component.userComponent()>
            <cfset variables.categoryResult = variables.userCateObject.listCategories(categoryId = decrypt(url.categoryId,application.encryptionString,"AES","Base64"))>
            <cfset variables.randomProductsResult = variables.userCateObject.getRandomProducts(sort="negative")>
            <cfset variables.subCategoryResult = variables.userCateObject.listSubCategories(categoryId = decrypt(url.categoryId,application.encryptionString,"AES","Base64"))>
            <cfinclude  template="./userHeader.cfm">
            <div class="pageFullPath ms-3 mt-2">
                <a href="./userhomePage.cfm">Return to Home Page</a>
                <i class="fa-solid fa-chevron-right fa-xs"></i> 
            </div>
            <div class="p-3">
                <h2>#variables.categoryResult.fldCategoryName# - All Products</h2>
            </div>
            <div>
                <div>
                    <cfloop query="subCategoryResult">
                        <cfif variables.subCategoryResult.fldCategoryId EQ variables.categoryResult.fldCategory_ID >
                            <div class="randomProductsHead">
                                <a class="randomAnchor" href="./subCategoriesListingPage.cfm?subCategoryId=#encodeForURL(encrypt(variables.subCategoryResult.fldsubCategory_ID,application.encryptionString,'AES','Base64'))#">
                                    #variables.subCategoryResult.fldSubcategoryName#
                                </a>
                            </div>
                            <div class="randomProductsMainDiv">
                                <cfloop query="randomProductsResult">
                                    <cfif randomProductsResult.fldSubCategoryId EQ variables.subCategoryResult.fldsubCategory_ID>
                                            <div class="card randomProductCard" style="width: 13rem;">
                                                <a class="text-decoration-none" href="./productPage.cfm?productId=#variables.randomProductsResult.fldProduct_ID#">
                                                    <img src="../Assets/ProductImages/#variables.randomProductsResult.fldImageFileName#" class="card-img-top randProductImage" alt="Product Image">
                                                    <div class="card-body randProductbody">
                                                        <div class="card-text randProductName">#variables.randomProductsResult.fldProductName#</div>
                                                        <div class='text-dark'>#variables.randomProductsResult.fldBrandName#</div>
                                                        <div class="card-text randProductPrice">
                                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                                            #variables.randomProductsResult.fldPrice + variables.randomProductsResult.fldTax#
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                    </cfif>
                                </cfloop>
                            </div>
                        </cfif>
                    </cfloop>
                    
                </div>
            </div>
            <cfinclude  template="./footer.cfm">
        </cfoutput>
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>