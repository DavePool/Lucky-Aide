
import java.awt.Color;
import java.awt.Desktop;
import java.net.URI;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;


public class OP_operacion_venta extends javax.swing.JFrame {
    conexionBD abd = new conexionBD();
    DefaultTableModel Carrito;
    DefaultComboBoxModel comboCliente, comboEmpleado;
    public OP_operacion_venta() {
        Carrito = new DefaultTableModel(null, getColumnas());
        comboEmpleado = new DefaultComboBoxModel(new String[] {});
        comboCliente = new DefaultComboBoxModel(new String[] {});
        initComponents();
        this.setLocationRelativeTo(null);
    }
  
    public String[] getColumnas(){
        String columna[] = new String[]{"Id", "Producto","Precio","Cantidad","Total"};
        return columna;
    }
    
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jLabel7 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jt1 = new javax.swing.JTextField();
        jSeparator4 = new javax.swing.JSeparator();
        jLabel13 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jLabel14 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jSeparator5 = new javax.swing.JSeparator();
        money1 = new javax.swing.JTextField();
        jLabel15 = new javax.swing.JLabel();
        jt2 = new javax.swing.JTextField();
        jSeparator6 = new javax.swing.JSeparator();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        cmbCliente = new javax.swing.JComboBox<>();
        cmbEmpleado = new javax.swing.JComboBox<>();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jButton3 = new javax.swing.JButton();
        jLabel5 = new javax.swing.JLabel();
        txtId = new javax.swing.JTextField();
        jButton4 = new javax.swing.JButton();
        jSeparator1 = new javax.swing.JSeparator();
        lblRegistrar = new javax.swing.JLabel();
        spCantidad = new javax.swing.JSpinner();
        jLabel6 = new javax.swing.JLabel();
        jButton2 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setBackground(new java.awt.Color(0, 153, 153));
        setUndecorated(true);
        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowOpened(java.awt.event.WindowEvent evt) {
                formWindowOpened(evt);
            }
        });
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));
        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        jPanel1.setForeground(new java.awt.Color(0, 153, 153));
        jPanel1.setDoubleBuffered(false);
        jPanel1.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jPanel2.setBackground(new java.awt.Color(0, 153, 153));
        jPanel2.setForeground(new java.awt.Color(0, 102, 102));

        jLabel7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/imagen/icons8_Multiply_32px.png"))); // NOI18N
        jLabel7.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jLabel7.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel7MouseClicked(evt);
            }
        });

        jLabel11.setBackground(new java.awt.Color(0, 102, 102));
        jLabel11.setFont(new java.awt.Font("Comic Sans MS", 1, 14)); // NOI18N
        jLabel11.setForeground(new java.awt.Color(255, 255, 255));
        jLabel11.setText("venta");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel11)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 831, Short.MAX_VALUE)
                .addComponent(jLabel7)
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel11)
                    .addComponent(jLabel7))
                .addGap(0, 8, Short.MAX_VALUE))
        );

        jPanel1.add(jPanel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 920, 40));

        jt1.setEditable(false);
        jt1.setForeground(new java.awt.Color(102, 102, 102));
        jt1.setBorder(null);
        jt1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jt1MouseClicked(evt);
            }
        });
        jPanel1.add(jt1, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 50, 140, 30));
        jPanel1.add(jSeparator4, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 210, 450, 20));

        jLabel13.setBackground(new java.awt.Color(0, 102, 102));
        jLabel13.setFont(new java.awt.Font("Comic Sans MS", 1, 14)); // NOI18N
        jLabel13.setForeground(new java.awt.Color(0, 102, 102));
        jLabel13.setText("Total:");
        jPanel1.add(jLabel13, new org.netbeans.lib.awtextra.AbsoluteConstraints(50, 60, -1, -1));

        jButton1.setText("Calcular total a pagar");
        jButton1.setBorder(null);
        jButton1.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jButton1.setEnabled(false);
        jButton1.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/imagen/Aceptar2.png"))); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        jPanel1.add(jButton1, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 170, 120, 40));

        jLabel14.setBackground(new java.awt.Color(0, 102, 102));
        jLabel14.setFont(new java.awt.Font("Comic Sans MS", 1, 14)); // NOI18N
        jLabel14.setForeground(new java.awt.Color(0, 102, 102));
        jLabel14.setText("Total a pagar:");
        jPanel1.add(jLabel14, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 230, -1, -1));

        jLabel3.setFont(new java.awt.Font("Arial", 1, 60)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(0, 204, 0));
        jLabel3.setText("$");
        jPanel1.add(jLabel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(60, 250, -1, -1));
        jPanel1.add(jSeparator5, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 80, 170, 20));

        money1.setFont(new java.awt.Font("Arial", 1, 50)); // NOI18N
        money1.setForeground(new java.awt.Color(0, 204, 0));
        money1.setText("00.00");
        money1.setBorder(null);
        jPanel1.add(money1, new org.netbeans.lib.awtextra.AbsoluteConstraints(100, 250, 340, -1));

        jLabel15.setBackground(new java.awt.Color(0, 102, 102));
        jLabel15.setFont(new java.awt.Font("Comic Sans MS", 1, 14)); // NOI18N
        jLabel15.setForeground(new java.awt.Color(0, 102, 102));
        jLabel15.setText("Descuento(%):");
        jPanel1.add(jLabel15, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 120, -1, -1));

        jt2.setForeground(new java.awt.Color(102, 102, 102));
        jt2.setBorder(null);
        jt2.setEnabled(false);
        jt2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jt2MouseClicked(evt);
            }
        });
        jt2.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jt2KeyPressed(evt);
            }
        });
        jPanel1.add(jt2, new org.netbeans.lib.awtextra.AbsoluteConstraints(120, 110, 140, 30));
        jPanel1.add(jSeparator6, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 150, 170, 20));

        jTable1.setModel(Carrito);
        jScrollPane1.setViewportView(jTable1);

        jPanel1.add(jScrollPane1, new org.netbeans.lib.awtextra.AbsoluteConstraints(510, 200, 400, 150));

        cmbCliente.setModel(comboCliente);
        cmbCliente.setEnabled(false);
        cmbCliente.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cmbClienteActionPerformed(evt);
            }
        });
        jPanel1.add(cmbCliente, new org.netbeans.lib.awtextra.AbsoluteConstraints(310, 60, 150, -1));

        cmbEmpleado.setModel(comboEmpleado);
        cmbEmpleado.setEnabled(false);
        jPanel1.add(cmbEmpleado, new org.netbeans.lib.awtextra.AbsoluteConstraints(310, 110, 150, -1));

        jLabel1.setText("Cliente");
        jPanel1.add(jLabel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(310, 40, -1, -1));

        jLabel2.setText("Empleado");
        jPanel1.add(jLabel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(310, 90, -1, -1));

        jLabel4.setText("Producto");
        jPanel1.add(jLabel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(530, 50, -1, -1));

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/imagen/car.png"))); // NOI18N
        jButton3.setText("Agregar articulo");
        jButton3.setBorder(null);
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });
        jPanel1.add(jButton3, new org.netbeans.lib.awtextra.AbsoluteConstraints(550, 120, 160, 50));

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 24)); // NOI18N
        jLabel5.setText("Carrito de compras");
        jPanel1.add(jLabel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(620, 170, -1, -1));
        jPanel1.add(txtId, new org.netbeans.lib.awtextra.AbsoluteConstraints(530, 70, 110, -1));

        jButton4.setText("Consulta");
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });
        jPanel1.add(jButton4, new org.netbeans.lib.awtextra.AbsoluteConstraints(660, 70, 80, -1));

        jSeparator1.setOrientation(javax.swing.SwingConstants.VERTICAL);
        jPanel1.add(jSeparator1, new org.netbeans.lib.awtextra.AbsoluteConstraints(492, 60, 10, 340));

        lblRegistrar.setBackground(new java.awt.Color(51, 51, 255));
        lblRegistrar.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        lblRegistrar.setText("Registrar compra");
        lblRegistrar.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 0, 0), 1, true));
        lblRegistrar.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        lblRegistrar.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                lblRegistrarMouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                lblRegistrarMouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                lblRegistrarMouseExited(evt);
            }
        });
        jPanel1.add(lblRegistrar, new org.netbeans.lib.awtextra.AbsoluteConstraints(140, 330, 110, 30));

        spCantidad.setModel(new javax.swing.SpinnerNumberModel(1, 1, null, 1));
        jPanel1.add(spCantidad, new org.netbeans.lib.awtextra.AbsoluteConstraints(820, 70, 60, -1));

        jLabel6.setText("Cantidad");
        jPanel1.add(jLabel6, new org.netbeans.lib.awtextra.AbsoluteConstraints(820, 50, -1, -1));

        jButton2.setText("Pagar");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });
        jPanel1.add(jButton2, new org.netbeans.lib.awtextra.AbsoluteConstraints(590, 370, 220, 30));

        getContentPane().add(jPanel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 920, 410));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jLabel7MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseClicked
   
      super.dispose();
    }//GEN-LAST:event_jLabel7MouseClicked

    private void jt1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jt1MouseClicked
    
        jt1.setText("");
        
    }//GEN-LAST:event_jt1MouseClicked

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        float total = Float.parseFloat(jt1.getText())*(1-Float.parseFloat(jt2.getText())/100);
        money1.setText(String.valueOf(total));
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jt2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jt2MouseClicked
        // TODO add your handling code here:
    }//GEN-LAST:event_jt2MouseClicked

    private void jt2KeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jt2KeyPressed
        // TODO add your handling code here:
    }//GEN-LAST:event_jt2KeyPressed

    private void formWindowOpened(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowOpened
        JOptionPane.showMessageDialog(null,abd.conectarBD(),"Informacion que cura :v",JOptionPane.INFORMATION_MESSAGE);
        llenarComboCliente();
        llenarComboEmpleado();
        lblRegistrar.setVisible(false);
    }//GEN-LAST:event_formWindowOpened

    public void llenarComboCliente(){
       ResultSet rst = abd.llenarTabla("cliente");
       try{
            while(rst.next()){
                comboCliente.addElement(rst.getString("nombre"));
            }
       }catch (SQLException e){
           JOptionPane.showMessageDialog(null, e.getMessage());
       }  
    }
    
    public void llenarComboEmpleado(){
       ResultSet rst = abd.llenarTabla("vendedor");
       try{
            while(rst.next()){
                comboEmpleado.addElement(rst.getString("nombre"));
            }
       }catch (SQLException e){
           JOptionPane.showMessageDialog(null, e.getMessage());
       }  
    }
    
    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        new producto().show();
    }//GEN-LAST:event_jButton4ActionPerformed

    private void lblRegistrarMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_lblRegistrarMouseClicked
        JOptionPane.showMessageDialog(null, abd.agregarVenta(Float.parseFloat(money1.getText()), Integer.parseInt(jt2.getText())));
        for (int i = 0; i < jTable1.getRowCount(); i++) {
            JOptionPane.showMessageDialog(null, abd.agregarDetalle((int)jTable1.getValueAt(i, 0), abd.getIdUltimaVenta(), (int)jTable1.getValueAt(i, 3)));
        }
        JOptionPane.showMessageDialog(null, abd.agregarVende(abd.getIdUltimaVenta(), abd.consultaVendedor(String.valueOf(cmbEmpleado.getSelectedItem()))));
        JOptionPane.showMessageDialog(null, abd.agregarCompra(abd.getIdUltimaVenta(), abd.consultaCliente(String.valueOf(cmbCliente.getSelectedItem()))));
        jt1.setText("");
        jt2.setText("");
        money1.setText("00.00");
    }//GEN-LAST:event_lblRegistrarMouseClicked

    private void lblRegistrarMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_lblRegistrarMouseEntered
        lblRegistrar.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(51,51,255)));
    }//GEN-LAST:event_lblRegistrarMouseEntered

    private void lblRegistrarMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_lblRegistrarMouseExited
        lblRegistrar.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0,0,0)));
    }//GEN-LAST:event_lblRegistrarMouseExited

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        setFilas();
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        int res = JOptionPane.showConfirmDialog(null, "Está seguro que desea pasar a pagar?","¿Seguro?",JOptionPane.YES_NO_OPTION);
        if (res==0) {
            jt1.setEnabled(true);
            jt2.setEnabled(true);
            cmbCliente.setEnabled(true);
            cmbEmpleado.setEnabled(true);
            jButton1.setEnabled(true);
            lblRegistrar.setVisible(true);
            
            spCantidad.setEnabled(false);
            txtId.setEnabled(false);
            jButton4.setEnabled(false);
            jButton3.setEnabled(false);
            jTable1.setEnabled(false);
            jButton2.setEnabled(false);
            int acum=0;
            for (int i = 0; i < jTable1.getRowCount(); i++) {
                acum = acum + (int)jTable1.getValueAt(i, 4 );
            }
            
            jt1.setText(String.valueOf(acum));
        }
    }//GEN-LAST:event_jButton2ActionPerformed

    private void cmbClienteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cmbClienteActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_cmbClienteActionPerformed
    
    public void setFilas(){
        try {
            ResultSet rst = abd.llenarProducto(Integer.parseInt(txtId.getText()));
            Object datos[] = new Object[5];
            if (rst.next()) {
                datos[0]=rst.getObject(1);//id
                datos[1]=rst.getObject(2);//producto
                datos[2]=rst.getObject(3);//precio
                datos[3]=(int)spCantidad.getValue();//cantidad
                datos[4]=(int)spCantidad.getValue()*rst.getInt(3);//total=cantidad*precio
            }
            Carrito.addRow(datos);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        }
    }
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Windows".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(login.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(login.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(login.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(login.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new login().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox<String> cmbCliente;
    private javax.swing.JComboBox<String> cmbEmpleado;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JSeparator jSeparator4;
    private javax.swing.JSeparator jSeparator5;
    private javax.swing.JSeparator jSeparator6;
    private javax.swing.JTable jTable1;
    private javax.swing.JTextField jt1;
    private javax.swing.JTextField jt2;
    private javax.swing.JLabel lblRegistrar;
    private javax.swing.JTextField money1;
    private javax.swing.JSpinner spCantidad;
    private javax.swing.JTextField txtId;
    // End of variables declaration//GEN-END:variables
}
