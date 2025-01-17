<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Home Page</title>
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfoutput>
            <cfset userCateObject = new Component.userComponent()>
            <cfset categoryResult = userCateObject.listCategories(url.categoryId)>
            <cfset randomProductsResult = userCateObject.getRandomProducts()>
            <cfset subCategoryResult = userCateObject.listSubCategories()>
            <cfinclude  template="./userHeader.cfm">
            <div class="p-3">
                <h2>#categoryResult.fldCategoryName# - All Products</h2>
            </div>
            <div>
                <div>
                    <cfloop query="subCategoryResult">
                        <cfif subCategoryResult.fldCategoryId EQ categoryResult.fldCategory_ID >
                            <div class="randomProductsHead">#subCategoryResult.fldSubcategoryName#</div>
                            <div class="randomProductsMainDiv">
                                <cfloop query="randomProductsResult">
                                    <cfif randomProductsResult.fldSubCategoryId EQ subCategoryResult.fldsubCategory_ID>
                                        <div class="card randomProductCard" style="width: 13rem;">
                                            <a href="#randomProductsResult.fldImageFileName#">
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