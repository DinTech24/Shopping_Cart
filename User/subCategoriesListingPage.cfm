<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Home Page</title>
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <link rel="icon" type="image/x-icon" href="../Assets/SiteImages/LogoImage.png">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap" rel="stylesheet">
    </head>
    <body>
        <cfoutput>
            <cfset variables.usersubCategoryObject = new Component.userComponent()>
            <cfset variables.encryptionString = variables.usersubCategoryObject.getSecretKey()>
            <cfif structKeyExists(url,"subCategoryId")>
                <cfset variables.subCategoryId = decrypt(url.subCategoryId,variables.encryptionString,"AES","Base64")>
            </cfif>
            <cfif structKeyExists(form,"highSort")>
                <cfset variables.productsResult = variables.usersubCategoryObject.getRandomProducts(
                    sort = form.highSort,
                    subCategoryId = variables.subCategoryId
                )>
            <cfelseif structKeyExists(form, "lowSort")>
                <cfset variables.productsResult = variables.usersubCategoryObject.getRandomProducts(
                    sort = form.lowSort,
                    subCategoryId = variables.subCategoryId
                )>
            <cfelseif structKeyExists(url, "searchKeyword")>
                <cfset variables.productsResult = variables.usersubCategoryObject.getRandomProducts(
                    searchKeyword = url.searchKeyword,
                    sort = "true"
                )>
            <cfelseif structKeyExists(url,"subCategoryId")>
                <cfset variables.productsResult = variables.usersubCategoryObject.getRandomProducts(
                    sort="negative",
                    subCategoryId = variables.subCategoryId
                )>
            </cfif>
            <cfinclude  template="./userHeader.cfm">
            <cfif NOT structKeyExists(url, "searchKeyword")>
                <cfif queryRecordCount(variables.productsResult) EQ 0>
                    <div class="fs-4 fw-bold ms-2">No products to display<div>
                    <cfabort> 
                </cfif>
                <div class="pageFullPath ms-2 mt-2">
                    <a href="./categoriesListingPage.cfm?categoryId=#encodeForURL(encrypt(variables.productsResult.fldCategoryId,variables.encryptionString,'AES','Base64'))#">
                        Return to Category Page
                    </a>
                    <i class="fa-solid fa-chevron-right fa-xs"></i> 
                </div>
                <div class="p-3 d-flex justify-content-between px-2">
                    <h2>#variables.productsResult.fldSubcategoryName# - All Products</h2>
                    <form method="POST">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <span class="sortText">Sort on price :</span>
                                <button class="sortArrow text-success"  data-bs-toggle="tooltip" data-bs-placement="bottom" title="Sort in ascending Order" value="ASC" name="highSort">
                                    <i class="fa-solid fa-arrow-up"></i>
                                </button>
                                <button class="sortArrow text-danger"  data-bs-toggle="tooltip" data-bs-placement="bottom" title="Sort in descending Order" value="DESC" name="lowSort">
                                    <i class="fa-solid fa-arrow-down"></i>
                                </button>
                            </div>
                            <div class="filterMainClass dropdown">
                                <button class="sortText filterClass dropdown-toggle type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" mt-1">
                                    Filter
                                    <i class="fa-solid fa-filter"></i>
                                </button>
                                <div class="filterInner dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                    <div>Select Price Range :</div>
                                    <div class="d-flex">
                                        <input type="radio" id="filterRadio1" onclick="disableInputs()" value='["0","1000"]' class="filterInput" name="filter">
                                        <label>upto 1000</label>
                                    </div>
                                    <div class="d-flex">
                                        <input type="radio" id="filterRadio2" onclick="disableInputs()" value='["1000","10000"]'class="filterInput" name="filter">
                                        <label>1000 to 10000</label>
                                    </div>
                                    <div class="d-flex">
                                        <input type="radio" id="filterRadio3" onclick="disableInputs()" value='["10000","25000"]' class="filterInput" name="filter">
                                        <label>10000 to 25000</label>
                                    </div>
                                    <div class="d-flex">
                                        <input type="radio" id="filterRadio4" onclick="disableInputs()" value='["25000","200000"]' class="filterInput" name="filter">
                                        <label>25000 to 200000</label>
                                    </div>
                                    <div class="d-flex">
                                        <input type="radio" id="filterRadio5" onclick="enableInputs()" value='range' class="filterInput" name="filter">
                                        <label>Custom Range</label>
                                    </div>
                                    <div class="text-center">
                                        <div class="mt-2">
                                            <input type="text" disabled id="minVal" placeholder="MIN" class="selectRange form-control border-danger">
                                            <div class="text-center fw-bold">Enter custom range</div>
                                            <input type="text" disabled id="maxVal" placeholder="MAX" class="selectRange form-control border-success">
                                        </div>
                                        <button type="button" class="btn btn-primary mt-2" onclick="getFilterResult(#variables.subCategoryId#)">Show result</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <form>
                </div>
            <cfelse>
                <cfif queryRecordCount(variables.productsResult)>
                    <h4 class="m-3">Results for your search "#url.searchKeyword#"</h4>
                <cfelse>
                    <h4 class="m-3">No result based on your search "#url.searchKeyword#"</h4>
                </cfif>
            </cfif>
            <div>
                <div>
                    <div class="randomProductsMainDiv" id="randomProductsMainDivId">
                        <cfset variables.productsCount = 0>
                        <cfset variables.productsArray = []>
                        <cfloop query="variables.productsResult">
                            <cfif variables.productsCount LT 12>
                                <cfset variables.productsCount = variables.productsCount + 1>
                                <div class="card randomProductCard" style="width: 13rem;">
                                    <a class="text-decoration-none" href="./productPage.cfm?productId=#variables.productsResult.fldProduct_ID#">
                                        <img src="../Assets/ProductImages/#variables.productsResult.fldImageFileName#" class="card-img-top randProductImage" alt="Product Image">
                                        <div class="card-body randProductbody">
                                            <div class="card-text randProductName">#variables.productsResult.fldProductName#</div>
                                            <div class="text-dark">#variables.productsResult.fldBrandName#</div>
                                            <div class="card-text randProductPrice">
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                                #variables.productsResult.fldPrice + (variables.productsResult.fldTax * variables.productsResult.fldPrice)/100#
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            <cfelseif variables.productsCount GT 11>
                                <cfset arrayAppend(variables.productsArray,productsResult.fldProduct_ID)>
                            </cfif>
                        </cfloop>
                    </div>
                </div>
            </div>
            <div class="text-center mb-3" id="viewMore">
                <cfif variables.productsCount EQ 12>
                    <cfset variables.listData = arrayToList(variables.productsArray)>
                    <button type="button" name="loadMoreProducts" value="1" id="loadMoreData" onclick="loadAllProducts('#variables.listData#',this)" class="btn btn-secondary">
                        Load More
                        <i class="fa-solid fa-circle-chevron-down"></i>
                    </button>
                </cfif>
            </div>
            <cfinclude  template="./footer.cfm">
        </cfoutput>
        <script src="./Script/userPage.js"></script>
        <script src="../CommonScripts/validations.js"></script>
        <script src="./Bootstrap/popper.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>