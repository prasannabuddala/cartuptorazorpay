package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class GetCategoriesDAL {
	private DatabaseConnection dbConnection = new DatabaseConnection();;

	List<Categories> catList = new ArrayList<>();
	Connection cn;

	public GetCategoriesDAL() {
		try {
			Class.forName("org.postgresql.Driver");
			cn = dbConnection.getConnection();
		} catch (SQLException e1) {
			System.out.println(e1.getMessage());
		} catch (ClassNotFoundException e) {
			System.out.println(e.getMessage());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public List<Categories> getCategories() {
		try {
			Statement st = cn.createStatement();
			ResultSet rs = st.executeQuery("select * from public.\"ProductCategories\"");
			while (rs.next()) {
				int cid = rs.getInt("cat_id");
				String cname = rs.getString("cat_name");
				Categories pcat = new Categories(cid, cname);
				catList.add(pcat);
			}
		} catch (SQLException e1) {
			System.out.println(e1.getMessage());
		}
		return catList;
	}
}
