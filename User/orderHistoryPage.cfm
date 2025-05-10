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
            <cfset orderHistoryObject = new Component.userComponent()>
            <cfset userResult = orderHistoryObject.displayOrderHistory()>
            <div>
                <div class="mainSectionBody " id="#variables.cartProductDisplayResult.fldCart_ID#CartProduct">
                    <div class="orderDetailsDiv pt-4">
                        <a href="./productPage.cfm?productId=#variables.cartDisplayResult.fldProduct_ID#">
                            <img class="cartImage" src="../Assets/ProductImages/#cartDisplayResult.fldImageFileName#" alt="">
                        </a>
                        <div class="mt-2 ms-5">
                            <div class="productNameSize">#variables.cartDisplayResult.fldProductName#</div>
                            <span class="orderDetailsSpan1">#variables.cartDisplayResult.fldBrandName#</span>
                            <div class="mt-3">	
                                <div class="orderDetailsSpan3 mt-1">
                                    Product Price : 
                                    <span>
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <span id="#variables.cartProductDisplayResult.fldCart_ID#unitprice">
                                            #variables.cartDisplayResult.fldPrice#
                                        </span>
                                    </span>
                                </div>
                                <div class="orderDetailsSpan3 mt-1">
                                    Product Tax : 
                                    <span>
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <span id="#variables.cartProductDisplayResult.fldCart_ID#unittax">
                                            #variables.cartDisplayResult.fldTax#
                                        </span>
                                    </span>
                                </div>
                                <div class="orderDetailsSpan mt-4">
                                    Product Total Amount : <i class="fa-solid fa-indian-rupee-sign"></i>
                                    #variables.cartDisplayResult.fldPrice + variables.cartDisplayResult.fldTax#
                                </div>
                            </div>	
                        </div>
                    </div>
                    <div class="d-flex w-50 ms-5 mt-2 justify-content-between mb-3">
                        <div>
                            <button class="prquanityIncrease" value="#variables.cartProductDisplayResult.fldCart_ID#" onclick="reduceProductQuantity(this)">-</button>
                            <span class="prquanity" id="#variables.cartProductDisplayResult.fldCart_ID#quantity">#variables.cartProductDisplayResult.fldQuantity#</span>
                            <button class="prquanityIncrease" value="#variables.cartProductDisplayResult.fldCart_ID#" id="addProductButton" onclick="addProductQuantity(this,#variables.productQuantity#)">+</button>
                        </div>
                        <button value="#variables.cartProductDisplayResult.fldCart_ID#" onclick="removeCart(this)" class="fontWeight">REMOVE</button>
                    </div>
                </div>
            </div>
            <cfinclude  template="./footer.cfm">
        </cfoutput>
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>