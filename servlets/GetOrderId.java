package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;

@WebServlet("/GetOrderId")
public class GetOrderId extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RazorpayClient razorpay = null;
		try {
			razorpay = new RazorpayClient("rzp_test_RvVefwk0s49Xft", "Jz5o3XRufCVJo2GMMNcXdPVk");
		} catch (RazorpayException e1) {
			System.out.println(e1.getMessage());
		}

		JSONObject orderRequest = new JSONObject();
		orderRequest.put("amount", 50000);
		orderRequest.put("currency", "INR");
		orderRequest.put("receipt", "receipt#1");
		JSONObject notes = new JSONObject();
		notes.put("notes_key_1", "Tea, Earl Grey, Hot");
		orderRequest.put("notes", notes);
		Order order = null;

		try {
			order = razorpay.Orders.create(orderRequest);
		} catch (RazorpayException e) {
			System.out.println(e.getMessage());
		}
		String orderId = order.get("id");
		String currency = order.get("currency");
		int amount = order.get("amount");
		System.out.println(orderId + " " + currency + " " + amount);
		JSONObject res = new JSONObject();
		res.put("orderid", orderId);
		res.put("amount", amount);
		res.put("currency", currency);

		response.setContentType("application/json");
		PrintWriter pw = response.getWriter();
		pw.print(res.toString());
	}

}
