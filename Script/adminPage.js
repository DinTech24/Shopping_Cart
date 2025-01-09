function adminLogin(){
    var adminuser = document.getElementById("adminUsername").value;
    var adminpassword = document.getElementById("adminPassword").value;
    var flag = true;
    if(adminuser.trim().length == 0){
        document.getElementById("userWarning").innerHTML = "enter username to login"
        flag = false;
    }else{
        document.getElementById("userWarning").innerHTML = ""
    }
    if(adminpassword.trim().length == 0){
        document.getElementById("passwordWarning").innerHTML = "enter password to login"
        flag = false;
    }else{
        document.getElementById("passwordWarning").innerHTML = ""
    }
    if(!flag){
        event.preventDefault();
    }
}

function categoryValidation(){
    var newcategory = document.getElementById("categoryId").value;
    if(newcategory.trim().length == 0){
        document.getElementById("addcategoryWarning").innerHTML = "enter category name"
        return false;
    }else{
        $.ajax({
            type:"POST",
            data:{newCategory:newcategory},
            url:"Component/adminComponent.cfc?method=insertCategories",
            success:function(){
                location.reload()
            }
        })
    }
}

function closeAdminModal(){
    document.getElementById("adminCategoryForm").reset();
    document.getElementById("addcategoryWarning").innerHTML = ""
}

function logout(){
    if(confirm("Confirm to logout")){
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=adminLogout",
            success:function(){
                    location.reload()
            }
        })
    }
}

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}
