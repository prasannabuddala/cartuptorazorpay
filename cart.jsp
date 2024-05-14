<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="servlets.CartItem" %>
<%@ page import="servlets.GetProductsDAL" %>
<%@ page import="servlets.Products" %>
<%@ page import="com.google.gson.Gson" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Cart</title>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style>
body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

       .product {
    border: 1px solid #ccc;
    padding: 10px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #fff;
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
    border-radius: 5px;
}

.product-details {
    flex-grow: 1;
}

.product p {
    margin: 5px 0;
}

.quantity-btns button {
    padding: 5px 10px;
    cursor: pointer;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 3px;
}

.quantity-btns button:hover {
    background-color: #0056b3;
}
#checkout-btn {
    padding: 10px 20px;
    cursor: pointer;
    background-color: #28a745; /* Green color */
    color: #fff;
    border: none;
    border-radius: 5px;
    font-size: 16px;
    transition: background-color 0.3s ease;
}

#checkout-btn:hover {
    background-color: #218838; /* Darker green color on hover */
}
</style>
</head>
<body>
<div class="container">
<h1>Welcome to Cart</h1>
<%
    GetProductsDAL productsDAL = new GetProductsDAL(); // Instantiate GetProductsDAL
    List<CartItem> cartitems = (ArrayList<CartItem>) session.getAttribute("cartitems");
    if (cartitems != null && cartitems.isEmpty() == false) {
        for (CartItem item : cartitems) {
            Products product = productsDAL.getProductById(item.getPid()); // Fetch product details
%>
    <div id="product_<%= product.getPid() %>" class="product">
    <div class="product-details">
        <p class="product-name"><b>Product Name:</b> <%= product.getPname() %></p>
        <p class="quantity"><b>Quantity:</b> <span id="quantity_<%= product.getPid() %>"><%= item.getQuantity() %></span></p>
        <p class="cost"><b>Cost:</b> <%= product.getPprice() * item.getQuantity() %></p>
    </div>
    <div class="quantity-btns">
        <button class="decrease-btn" data-pid="<%= product.getPid() %>">-</button> 
        <button class="increase-btn" data-pid="<%= product.getPid() %>">+</button> 
    </div>
    <div class="remove-div">
        <button class="remove-btn" data-pid="<%= product.getPid() %>" id="remove">remove</button> 
    </div>
</div>
<%
        }
    }
    else{
    	%>
    	<p>no items here</p>
    	<%
    }
%>
<br />
<div id="empty"></div>
<button id="checkout-btn" class="button">Checkout</button>
</div>
<script>
var cartitemss = [];
const handlePaymentSuccess = (paymentResponse) => {
	$.ajax({
    url: "CheckoutController", 
    method: "POST",
    data: { cartitems: JSON.stringify(cartitemss) }, 
    success: function(response) {
        if (response.success) {
            window.location.href = "checkout.jsp?totalAmount=" + response.totalAmount;
        } else {
            alert("Cannot proceed to checkout");
        }
    },
    error: function() {
        alert("An error occurred while processing your request");
    }
}); 
};

const handlePaymentFailure = (error) => {
    alert('Payment failed: ' + error.error.description);
};

const initRazorpay = (orderId, amount, currency) => {
    var rzp = new Razorpay({
        key: 'rzp_test_RvVefwk0s49Xft',
        amount: amount, 
        currency: currency,
        order_id: orderId,
        handler: function (response) {
            if (response.razorpay_payment_id) {
                handlePaymentSuccess(response);
            } else {
                handlePaymentFailure(response.error);
            }
        },
        prefill: {
            name: 'John Doe',
            email: 'john@example.com',
            contact: '9999999999'
        }
    });

    rzp.open();
};
$(document).ready(function() {
    $(".increase-btn").click(function() {
        var pid = $(this).data("pid");
        $.ajax({
            url: "IncreaseQuantityController",
            method: "GET",
            data: { pid: pid },
            success: function(data) {
                var quantityElement = $("#quantity_" + pid);
                var newQuantity = parseInt(quantityElement.text()) + 1;
                quantityElement.text(newQuantity);
            }
        });
    });

    $(".decrease-btn").click(function() {
        var pid = $(this).data("pid");
        $.ajax({
            url: "DecreaseQuantityController",
            method: "GET",
            data: { pid: pid },
            success: function(data) {
                var quantityElement = $("#quantity_" + pid);
                var newQuantity = parseInt(quantityElement.text()) - 1;
                if (newQuantity >= 0) {
                    quantityElement.text(newQuantity);
                }
            }
        });
    });
    $(".remove-btn").click(function(){
    	var pid = $(this).data(pid);
    	$.ajax({
    		url : "RemoveCartItemController",
    		method : "GET",
    		data : {pid: pid},
    		success : function(data){
    			alert("removed from cart");
    		},
    		error : function(xhr,status,err){
    			console.log("error caling remove cartitem controller");
    		}
    	})
    })
    $("#checkout-btn").click(function() {
        $.ajax({
            url: "GetCartItemsServlet",
            method: "GET",
            success: function(cartitems) {
            	console.log(cartitems);
            	cartitemss = cartitems
                if (cartitems.status == "null") {
                    alert("Cannot proceed to checkout, items are null");
                } else {
                	var orderIdd;
                	$.ajax({
                		url : "GetOrderId",
                		method : "GET",
                		dataType : "json",
                		success : function(response){
                			console.log(response);
                			const orderId = response.orderid;
                            const amount = response.amount;
                            const currency = response.currency;
                            initRazorpay(orderId, amount, currency);
                		},
                		error : function(xhr,status,err){
                			console.log("error calling getorderid servlet", err);
                		}
                	});
                }
            },
            error: function() {
                alert("An error occurred while retrieving cart items");
            }
        });
    });
    

});
</script>
</body>
</html>
