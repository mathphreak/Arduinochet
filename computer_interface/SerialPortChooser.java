import javax.swing.*;
import java.awt.event.*;
import java.awt.*;

public class SerialPortChooser {
  private JFrame f;
  private JComboBox b;
  private JButton ok;
  private String res;
  
  public SerialPortChooser(String[] ports) {
    f = new JFrame("Arduinochet - Choose Port");
    b = new JComboBox(ports);
    ok = new JButton("OK");
    ok.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        SerialPortChooser.this.res = (String) b.getSelectedItem();
      }
    });
    f.add(b, BorderLayout.NORTH);
    f.add(ok, BorderLayout.SOUTH);
    f.pack();
    f.setVisible(true);
  }
  
  public boolean isReady() {
    return res != null;
  }
  
  public String getPort() {
    f.dispose();
    return res;
  }
}
