import java.sql.*;
import javax.swing.JOptionPane;
public class conexionBD {
    private Connection con;
    private PreparedStatement pst, pst2;
    private ResultSet rst;
    private String ruta="jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=luckyaide;";
    private String user="root";
    private String pass="";
    private String mensajeConexion="";
    
    public String conectarBD(){
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con=DriverManager.getConnection(ruta,user,pass);
            mensajeConexion="La conexion a la BD fue establecida exitosamente :)";
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return mensajeConexion;
    }
    
    public ResultSet llenarTabla(String tabla){
        try {
            pst2=con.prepareStatement("select * from "+tabla);
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }
    
    public int getIdUltimaVenta(){
        int id=0;
        try {
            pst2=con.prepareStatement("select max(id_venta) from venta");
            rst=pst2.executeQuery();
            if (rst.next()) {
               id=rst.getInt(1);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return id;
    }
    
    public ResultSet llenarProducto(int id){
        try {
            pst2=con.prepareStatement("select * from producto where id_producto="+id);
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }
    
    public ResultSet llenarTablaProvee(){
        try {
            pst2=con.prepareStatement("select provee.id_provee, proveedor.nombre, producto.nombre, provee.fecha, provee.cantidad from proveedor inner join provee on proveedor.id_proveedor=provee.id_proveedor inner join producto on producto.id_producto=provee.id_producto");
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }
    
    public ResultSet llenarTablaClasifica(){
        try {
            pst2=con.prepareStatement("select clasifica.id_clasifica, categoria.nombre, producto.nombre from categoria inner join clasifica on categoria.id_categoria=clasifica.id_categoria inner join producto on producto.id_producto=clasifica.id_producto;");
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }
    
    public ResultSet llenarTablaDetalle(){
        try {
            pst2=con.prepareStatement("select detalle.id_detalle, producto.nombre, venta.id_venta, venta.total, detalle.cantidad, detalle.fecha from producto inner join detalle on producto.id_producto=detalle.id_producto inner join venta on venta.id_venta=detalle.id_venta;");
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }

    public ResultSet llenarTablaCompra(){
        try {
            pst2=con.prepareStatement("select compra.id_compra, venta.id_venta, venta.fecha, venta.total, cliente.nombre from venta inner join compra on venta.id_venta=compra.id_venta inner join cliente on cliente.id_cliente=compra.id_cliente;");
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }
    
    public ResultSet llenarTablaRealiza(){
        try {
            pst2=con.prepareStatement("select realiza.id_realiza, venta.id_venta, venta.fecha, venta.total, vendedor.nombre from realiza inner join venta on venta.id_venta=realiza.id_venta inner join vendedor on vendedor.id_vendedor=realiza.id_vendedor;");
            rst=pst2.executeQuery();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return rst;
    }
    
    public String agregarProveedor(String n, String dir, String calle, String colonia, String num, String ciudad, int cp){
        try {
            String query = "INSERT INTO proveedor (nombre, direccion, calle, colonia, numero, ciudad, cp) VALUES (?,?,?,?,?,?,?)";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setString(2, dir);
            pst.setString(3, calle);
            pst.setString(4, colonia);
            pst.setString(5, num);
            pst.setString(6, ciudad);
            pst.setInt(7, cp);
            pst.executeUpdate();
            mensajeConexion="Registro insertado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String cambiarProveedor(String n, String dir, String calle, String colonia, String num, String ciudad, int cp, int id){
        try {
            String query = "update proveedor set nombre=?, direccion=?, calle=?, colonia=?, numero=?, ciudad=?, cp=? where id_proveedor=?";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setString(2, dir);
            pst.setString(3, calle);
            pst.setString(4, colonia);
            pst.setString(5, num);
            pst.setString(6, ciudad);
            pst.setInt(7, cp);
            pst.setInt(8, id);
            pst.executeUpdate();
            mensajeConexion="Registro actualizado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String eliminarRegistro(int id, String tabla){
        try {
            String query="delete from "+tabla+" where id_"+tabla+"=?";
            pst=con.prepareStatement(query);
            pst.setInt(1, id);
            pst.executeUpdate();
            mensajeConexion="Registro eliminado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarCategoria(String n, String desc){
        try {
            String query = "INSERT INTO categoria (nombre, descripcion) VALUES (?,?)";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setString(2, desc);
            pst.executeUpdate();
            mensajeConexion="Registro insertado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String cambiarCategoria(String n, String desc, int id){
        try {
            String query = "update categoria set nombre=?, descripcion=? where id_categoria=?";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setString(2, desc);
            pst.setInt(3, id);
            pst.executeUpdate();
            mensajeConexion="Registro actualizado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarCliente(String n, String dir, String calle, String colonia, String num, String ciudad, int cp){
        try {
            String query = "INSERT INTO cliente (nombre, direccion, calle, colonia, numero, ciudad, cp) VALUES (?,?,?,?,?,?,?)";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setString(2, dir);
            pst.setString(3, calle);
            pst.setString(4, colonia);
            pst.setString(5, num);
            pst.setString(6, ciudad);
            pst.setInt(7, cp);
            pst.executeUpdate();
            mensajeConexion="Registro insertado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String cambiarCliente(String n, String dir, String calle, String colonia, String num, String ciudad, int cp, int id){
        try {
            String query = "update cliente set nombre=?, direccion=?, calle=?, colonia=?, numero=?, ciudad=?, cp=? where id_cliente=?";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setString(2, dir);
            pst.setString(3, calle);
            pst.setString(4, colonia);
            pst.setString(5, num);
            pst.setString(6, ciudad);
            pst.setInt(7, cp);
            pst.setInt(8, id);
            pst.executeUpdate();
            mensajeConexion="Registro actualizado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarVendedor(String n, String fcontrato, String fnacimiento, String escolaridad){
        try {
            String query = "INSERT INTO vendedor (nombre, fecha_contrato, fecha_nacimiento, escolaridad) VALUES (?,?,?,?)";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setDate(2, Date.valueOf(fcontrato));
            pst.setDate(3, Date.valueOf(fnacimiento));
            pst.setString(4, escolaridad);
            pst.executeUpdate();
            mensajeConexion="Registro insertado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String cambiarVendedor(String n, String fcontrato, String fnacimiento, String escolaridad, int id){
        try {
            String query = "update vendedor set nombre=?, fecha_contrato=?, fecha_nacimiento=?, escolaridad=? where id_vendedor=?";
            pst=con.prepareStatement(query);
            pst.setString(1, n);
            pst.setDate(2, Date.valueOf(fcontrato));
            pst.setDate(3, Date.valueOf(fnacimiento));;
            pst.setString(4, escolaridad);
            pst.setInt(5, id);
            pst.executeUpdate();
            mensajeConexion="Registro actualizado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarVenta(float total, int desc){
        try {
            String query = "INSERT INTO venta (fecha, total, descuento) VALUES (default,?,?)";
            pst=con.prepareStatement(query);
            pst.setFloat(1, total);
            pst.setInt(2, desc);
            pst.executeUpdate();
            mensajeConexion="Venta realizada exitosamente";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarProducto(String nombre, float precio, int exis){
        try {
            String query = "INSERT INTO producto (nombre, precio, existencias) VALUES (?,?,?)";
            pst=con.prepareStatement(query);
            pst.setString(1, nombre);
            pst.setFloat(2, precio);
            pst.setInt(3, exis);
            pst.executeUpdate();
            mensajeConexion="Registro ingresado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String cambiarProducto(String nombre, float precio, int exis, int id){
        try {
            String query = "update producto set nombre=?, precio=?, existencias=? where id_producto=?";
            pst=con.prepareStatement(query);
            pst.setString(1, nombre);
            pst.setFloat(2, precio);
            pst.setInt(3, exis);
            pst.setInt(4, id);
            pst.executeUpdate();
            mensajeConexion="Registro actualizado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarClasifica(int producto, int categoria){
        try {
            String query = "INSERT INTO clasifica (id_categoria, id_producto) VALUES (?,?)";
            pst=con.prepareStatement(query);
            pst.setInt(1, categoria);
            pst.setInt(2, producto);
            pst.executeUpdate();
            mensajeConexion="Registro ingresado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarProveer(int proveed, int producto, String fecha, int cantidad){
        try {
            String query = "INSERT INTO provee (id_proveedor, id_producto, fecha, cantidad) VALUES (?,?,?,?)";
            pst=con.prepareStatement(query);
            pst.setInt(1, proveed);
            pst.setInt(2, producto);
            pst.setDate(3, Date.valueOf(fecha));
            pst.setInt(4, cantidad);
            pst.executeUpdate();
            mensajeConexion="Registro ingresado";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarDetalle(int producto, int venta, int cantidad){
        try {
            String query = "INSERT INTO detalle (id_producto, id_venta, cantidad, fecha) VALUES (?,?,?,default)";
            pst=con.prepareStatement(query);
            pst.setInt(1, producto);
            pst.setInt(2, venta);
            pst.setInt(3, cantidad);
            pst.executeUpdate();
            mensajeConexion="Detalle de la venta generado exitosamente";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public int consultaVendedor(String nombre){
        int id=0;
        try {
            pst2=con.prepareStatement("select id_vendedor from vendedor where nombre='"+nombre+"'");
            rst=pst2.executeQuery();
            if (rst.next()) {
                id=rst.getInt(1);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return id;
    }
    
    public int consultaCliente(String nombre){
        int id=0;
        try {
            pst2=con.prepareStatement("select id_cliente from cliente where nombre='"+nombre+"'");
            rst=pst2.executeQuery();
            if (rst.next()) {
                id=rst.getInt(1);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
        return id;
    }
    
    
    public String agregarCompra(int venta, int cliente){
        try {
            String query = "INSERT INTO compra (id_venta, id_cliente) VALUES (?,?)";
            pst=con.prepareStatement(query);
            pst.setInt(1, venta);
            pst.setInt(2, cliente);
            pst.executeUpdate();
            mensajeConexion="Compra realizada";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
    public String agregarVende(int venta, int vendedor){
        try {
            String query = "INSERT INTO realiza (id_venta, id_vendedor) VALUES (?,?)";
            pst=con.prepareStatement(query);
            pst.setInt(1, venta);
            pst.setInt(2, vendedor);
            pst.executeUpdate();
            mensajeConexion="Venta realizada";
        } catch (SQLException e) {
            mensajeConexion=e.getMessage();
        }
        return mensajeConexion;
    }
    
}
