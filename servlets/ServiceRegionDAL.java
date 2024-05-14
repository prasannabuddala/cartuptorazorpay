package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ServiceRegionDAL {
	int serviceRegId;
	Connection cn;
	DatabaseConnection dbConnection = new DatabaseConnection();

	public ServiceRegionDAL() {
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

	public boolean isPincodeAvailable(int prodId, int pincode) {
		GetProductsDAL dal = new GetProductsDAL();
		int catid = dal.getCatIdByPid(prodId);
		System.out.println("cat" + catid);
		int srId = -1;
		int pinfrom = 0, pinto = 0;
		String query = "select srrg_id from ProductCategoryWiseServiceableRegions_pr where prct_id = ?";
		PreparedStatement pst;
		try {
			pst = cn.prepareStatement(query);
			pst.setInt(1, catid);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				srId = rs.getInt(1);
				System.out.println(srId + " srid");
			}
		} catch (SQLException e) {
			System.out.println("ha" + e.getMessage());
		}
		if (srId != -1) {
			try {
				String query1 = "select srrg_pinfrom,srrg_pinto from ServiceableRegions_pr where srrg_id  = ?";
				PreparedStatement pst1;
				pst1 = cn.prepareStatement(query1);
				pst1.setInt(1, srId);
				ResultSet rs = pst1.executeQuery();
				while (rs.next()) {
					pinfrom = rs.getInt(1);
					pinto = rs.getInt(2);
				}

			} catch (SQLException e1) {
				System.out.println(e1.getMessage());
			}
			if (pincode >= pinfrom && pincode <= pinto) {
				return true;
			} else {
				System.out.println("pincode out of range");
			}

		} else {
			System.out.println("this product category has no shipping");
		}
		return false;
	}

}
