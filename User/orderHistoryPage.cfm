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
        <cfinclude  template="./userHeader.cfm">
        <cfoutput>
            <cfset orderHistoryObject = new Component.userComponent()>
            <cfset userResult = orderHistoryObject.displayOrderHistory()>
            <div>
                <div class="p-3 border border-secondary">
                    <div class="fs-2">Order History</div>
                </div>
                <div class="mainSectionBody ">
                    <div class="orderDetailsDiv pt-4">
                        <a href="./productPage.cfm?productId=##">
                            <img class="cartImage" src="../Assets/ProductImages/" alt="">
                        </a>
                        <div class="mt-2 ms-5">
                            <div class="productNameSize">3f</div>
                            <span class="orderDetailsSpan1">g4r</span>
                            <div class="mt-3">	
                                <div class="orderDetailsSpan3 mt-1">
                                    Product Price : 
                                    <span>
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <span id="4g54">
                                            g
                                        </span>
                                    </span>
                                </div>
                                <div class="orderDetailsSpan3 mt-1">
                                    Product Tax : 
                                    <span>
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <span id="unittax">
                                           wefewfe
                                        </span>
                                    </span>
                                </div>
                                <div class="orderDetailsSpan mt-4">
                                    Product Total Amount : <i class="fa-solid fa-indian-rupee-sign"></i>
                                    
                                </div>
                            </div>	
                        </div>
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