function adminLogin(){
    var adminuser = document.getElementById("adminUsername").value;
    var adminpassword = document.getElementById("adminPassword").value;
    var flag = true;

    flag = validateData(adminuser,"userWarning","enter username to login")
    flag = validateData(adminpassword,"passwordWarning","enter password to login")
    if(!flag){
        event.preventDefault();
        replaceElement("loginException","")
    }
}

function subCategoryValidation(){
    var newsubCategory = document.getElementById("subCategoryId").value;
    flag = validateData(newsubCategory,"addcategoryWarning","enter Sub-Category name")
    return flag;
}

function validateEditSub(){
    var newsubcategory = document.getElementById("editSubCategoryId").value
    flag = validateData(newsubcategory,"addDiffcategoryWarning","enter Sub-Category name")
    return flag;
}

function validateProductImage() {
    var productImage = document.getElementById("productImageId").files;
    var allowedExtensions = /(\.jpg|\.jpeg|\.png)$/i;
    let flag = true;
    const maxSize = 1048576;
    if (productImage.length === 0) {
        replaceElement("imageWarning","Profile image should be added")
    }else {
        var file = productImage[0];  
        var fileName = file.name;  
        if (!allowedExtensions.test(fileName)) {
            replaceElement("imageWarning","Allowed extensions are JPG/JPEG/PNG") 
            flag = false;
        } else if (file.size > maxSize) {
            replaceElement("imageWarning","File size should not exceed 1MB") 
            flag = false;
        } else {
            replaceElement("imageWarning","") 
        }
    }
    return flag;
}

function registerUser(){
    var firstName = document.getElementById("firstNameId").value;
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var rePassword = document.getElementById("rePasswordId").value;
    var phone = document.getElementById("phoneId").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;

    flag = validateData(firstName,"nameWarning","Firstname is required")

    if(validateData(phone,"phoneWarning","add phone number") == false){
        flag = false
    }else{
        if(phonePattern.test(phone) === false){
            replaceElement("phoneWarning","phone should follow the pattern")
            flag = false;
        }else{
            replaceElement("phoneWarning","")
        }
    }

    if(validateData(emailId,"emailWarning","email-id is required") == false){
        flag = false
    }else{
        if(emailPattern.test(emailId) === false){
            replaceElement("emailWarning","should follow email Pattern")
            flag = false;
        }else{
            replaceElement("emailWarning","")
        }
    }

    if(validateData(password,"passWarning","password is required") == false){
        flag = false;
    }else{
        if(password.includes(" ")){
            replaceElement("passWarning","password shouldn't contain spaces")
            flag = false;
        }else if(password.length < 6){
            replaceElement("passWarning","password should atleast have 6 characters")
            flag = false;
        }else if(password !== rePassword){
            replaceElement("passWarning","")
            replaceElement("repassWarning","passwords doesn't match")
            flag = false;
        }else{
            replaceElement("passWarning","")
            replaceElement("repassWarning","")
        }
    }
    
    if(flag == false){
        replaceElement("signupError","")
        event.preventDefault();
    }
    return flag;
}

function loginModal(){
    replaceElement("passWarning","")
    replaceElement("emailWarning","")
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var flag = true;

    flag = validateData(emailId,"emailWarning","EmailId is required")

    flag = validateData(password,"passWarning","Password is required")
    
    if(flag){
        var jsCall = true;
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=loginUser",
            data:{enteredId:emailId,enteredPassword:password,jsCall:jsCall},
            success:function(result){
                if(result){
                    result = JSON.parse(result);
                    event.preventDefault();
                    if(result["Message"] == true){
                        location.reload();
                    }else{
                        replaceElement("passWarning",result["Message"])
                    }
                    
                }
            }
        })
    }
    
}

function verifyCard(cardData){
    const cardDataArray = cardData.value.split(",")
    var cardNumber = document.getElementById("cardNumberId").value;
    var cardMonth = document.getElementById("cardMonthId").value;
    var cardYear = document.getElementById("cardYearId").value;
    var cardCvv = document.getElementById("cardCvvId").value;
    var totalAmount = document.getElementById("totalAmount").innerHTML
    var flag = true;
    var error = ""
    if(cardNumber !== cardDataArray[0]){
        flag = false;
        error = "Card Number is wrong"
    }
    if((cardMonth !== cardDataArray[1])&&(flag == true)){
        flag = false;
        error = "Validity month is wrong"
    }
    if((cardYear !== cardDataArray[2]&&(flag == true))){
        flag = false;
        error = "Validity year is wrong"
    }
    if((cardCvv !== cardDataArray[3]&&(flag == true))){
        flag = false;
        error = "Card CVV is wrong"
    }
    if(flag == true){
        document.getElementById("cardWarningId").innerHTML = '<i class="fa-solid fa-check"></i> Verified'
        document.getElementById("cardWarningId").classList.add("text-success");
        document.getElementById("cardWarningId").classList.remove("text-danger");
        document.getElementById("placeOrderButtonId").disabled = false;
        document.getElementById("cardNumberId").readOnly  = true;
        document.getElementById("cardMonthId").readOnly = true;
        document.getElementById("cardYearId").readOnly = true;
        document.getElementById("cardCvvId").readOnly = true;
        document.getElementById("verifyButtonId").remove();
        document.getElementById("paymentsAmount").innerHTML = "Rs."+ totalAmount;
    }else{
        document.getElementById("cardWarningId").innerHTML = '<i class="fa-solid fa-xmark"></i> Unverified'
        document.getElementById("cardWarningId").classList.add("text-danger");
        document.getElementById("cardWarningId").classList.remove("text-success");
        document.getElementById("placeOrderButtonId").disabled = true;
        Swal.fire(error);
    }
}

function addressModalValidation(){
    var firstName = document.getElementById("firstNameId").value;
    var address1 = document.getElementById("address1Id").value;
    var city = document.getElementById("cityId").value;
    var state = document.getElementById("stateId").value;
    var pincode = document.getElementById("pincodeId").value;
    var phone = document.getElementById("phoneId").value;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;
    if(validateData(firstName,"firstWarning","firstName is required") == false){
        flag = false;
        document.getElementById("firstNameId").focus();
        document.getElementById("firstNameId").style.border = "2px solid red";
    }else{
        document.getElementById("firstNameId").style.border = "1px solid black";
    }

    if(validateData(address1,"address1Warning","address line 1 is required") == false){
        document.getElementById("address1Id").focus();
        document.getElementById("address1Id").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("address1Id").style.border = "1px solid black";
    }

    if(validateData(city,"cityWarning","city is required") == false){
        flag = false;
        document.getElementById("cityId").focus();
        document.getElementById("cityId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("cityId").style.border = "1px solid black";
    }

    if(validateData(state,"stateWarning","state is required") == false){
        document.getElementById("stateId").focus();
        document.getElementById("stateId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("stateId").style.border = "1px solid black";
    }
    
    if(validateData(pincode,"pincodeWarning","pincode is required") == false){
        document.getElementById("pincodeId").focus();
        document.getElementById("pincodeId").style.border = "2px solid red";
        flag = false;
    }else{
        if(pincode.length !== 6){
            replaceElement("pincodeWarning","enter 6 digit pincode")
            flag = false;
        }else if(/^[0-9]{6}$/.test(pincode) === false){
            replaceElement("pincodeWarning","pincode should only contain digits")
            flag = false;
        }else{
            replaceElement("pincodeWarning","")
            document.getElementById("pincodeId").style.border = "1px solid black";
        }
    }

    if(validateData(phone,"phoneWarning","Phone Number is required") == false){
        document.getElementById("phoneId").focus();
        document.getElementById("phoneId").style.border = "2px solid red";
        flag = false;
    }else{
        if(!phonePattern.test(phone)){
            replaceElement("phoneWarning","Phone Number should follow pattern")
            flag = false;
        }else{
            replaceElement("phoneWarning","")
            document.getElementById("phoneId").style.border = "1px solid black";
        }
    }
    if(flag == false){
        event.preventDefault()
    }
    return flag;
}

function validateData(data,warningId,message){
    flag = true;
    if(data.trim() === ""){
        replaceElement(warningId,message)
        flag = false;
    }else{
        replaceElement(warningId,"")
    }
    return flag;
}
function replaceElement(elementId,message){
    document.getElementById(elementId).innerHTML = message;
}
