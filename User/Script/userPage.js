function registerUser(){
    var firstName = document.getElementById("firstNameId").value;
    var lastName = document.getElementById("lastNameId").value;
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var rePassword = document.getElementById("rePasswordId").value;
    var phone = document.getElementById("phoneId").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;

    if(firstName.trim() === ""){
        document.getElementById("nameWarning").innerHTML = "Firstname is required"
        flag = false;
    }else{
        document.getElementById("nameWarning").innerHTML = ""
    }

    if(phone.trim() === ""){
        document.getElementById("phoneWarning").innerHTML = "add phone number";
        flag = false;
    }else{
        if(phonePattern.test(phone) === false){
            document.getElementById("phoneWarning").innerHTML = "phone should follow the pattern";
            flag = false;
        }else{
            document.getElementById("phoneWarning").innerHTML = ""
        }
    }

    if(emailId.trim() === ""){
        document.getElementById("emailWarning").innerHTML = "email-id is required"
        flag = false;
    }else{
        if(emailPattern.test(emailId) === false){
            document.getElementById("emailWarning").innerHTML = "should follow email Pattern"
            flag = false;
        }else{
            document.getElementById("emailWarning").innerHTML = ""
        }
    }


    if(password.trim() === ""){
        document.getElementById("passWarning").innerHTML = "password is required"
        flag = false;
    }else{
        if(password.includes(" ")){
            document.getElementById("passWarning").innerHTML = "password shouldn't contain spaces"
            flag = false;
        }else if(password.length < 6){
            document.getElementById("passWarning").innerHTML = "password should atleast have 6 characters"
            flag = false;
        }else if(password !== rePassword){
            document.getElementById("passWarning").innerHTML = ""
            document.getElementById("repassWarning").innerHTML = "passwords doesn't match"
            flag = false;
        }else{
            document.getElementById("repassWarning").innerHTML = ""
            document.getElementById("passWarning").innerHTML = ""
        }
    }
    
    if(flag == false){
        event.preventDefault();
    }
    return flag;
}

function logoutFunction(){
    if(confirm("Confirm to logout")){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=logoutUser",
            success:function(){
                    location.reload()
                }
        })
    }
}

function closeUserModal(){
    document.getElementById("userLoginForm").reset();
}

function loginModal(){
    document.getElementById("passWarning").innerHTML = ""
    document.getElementById("emailWarning").innerHTML = ""
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var flag = true;
    if(emailId.trim() === ""){
        document.getElementById("emailWarning").innerHTML = "EmailId is required"
        flag = false;
    }else{
        document.getElementById("emailWarning").innerHTML = ""
    }
    if(password.trim() === ""){
        document.getElementById("passWarning").innerHTML = "Password is required"
        flag = false;
    }else{
        document.getElementById("passWarning").innerHTML = ""
    }
    if(flag)
        var jsCall = true;
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=loginUser",
            data:{enteredId:emailId,enteredPassword:password,jsCall:jsCall},
            success:function(result){
                if(result){
                    result = JSON.parse(result);
                    event.preventDefault();
                    if(result["Message"] == "true"){
                        location.reload();
                    }else{
                        document.getElementById("passWarning").innerHTML = result["Message"]
                    }
                    
                }
            }
        })
    
}

function modalClear(){
    document.getElementById("userLoginForm").reset();
    document.getElementById("passWarning").innerHTML = ""
    document.getElementById("emailWarning").innerHTML = ""
}

function enableInputs(){
    document.getElementById("minVal").disabled = false;
    document.getElementById("maxVal").disabled = false;
}

function disableInputs(){
    document.getElementById("minVal").disabled = true;
    document.getElementById("maxVal").disabled = true;
}

function getFilterResult(subCategoryId){

    var flag = false;
    minVal = document.getElementById("minVal").value;
    maxVal = document.getElementById("maxVal").value;
    for(i=1;i<=4;i++){
        if(document.getElementById("filterRadio"+i).checked){
            flag = true
            var filterRangeVal = document.getElementById("filterRadio"+i).value;
            break;
        }else{
            if((i==4)&&(flag == false)){
                if((minVal=="")&&(maxVal=="")){
                    alert("Select a Range to continue")
                }else{
                    var filterRangeVal=`["${minVal}","${maxVal}"]`
                    flag=true
                }
            }
        }
    }
    if(flag==true){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=selectPriceRange",
            data:{filterRange:filterRangeVal,subCategoryId:subCategoryId},
            success:function(result){
                var result = JSON.parse(result)
                document.getElementById("randomProductsMainDivId").innerHTML = ""
                if(result.length == 0){
                    var emptyStatement = "No products to display in the price range"
                    $("#randomProductsMainDivId").append(emptyStatement);
                    document.getElementById("viewMore").style.display = "none"
                }else{
                    for(j=0;j<result.length;j++){
                        var eachProducts = 
                        `<div class="card randomProductCard" style="width: 13rem;">
                            <a href="./productPage.cfm?productId=${result[j].fldProduct_ID}">
                                <img src="../Assets/ProductImages/${result[j].fldImageFileName}" class="card-img-top randProductImage" alt="Product Image">
                            </a>
                            <div class="card-body randProductbody">
                                <div class="card-text randProductName">${result[j].fldProductName}</div>
                                <div>${result[j].fldBrandName}</div>
                                <div class="card-text randProductPrice">
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    ${result[j].fldPrice + result[j].fldTax}
                                </div>
                            </div>
                        </div>`
                        $("#randomProductsMainDivId").append(eachProducts);
                        document.getElementById("viewMore").style.display = "initial"
                    }
                }
            }
        })
    }
}

function removeHeightClass(){
    document.getElementById("randomProductsMainDivId").classList.remove("initialDivHeight");
    document.getElementById("viewMore").style.display = "none"
}


