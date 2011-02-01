import java.util.prefs.*;

public abstract class Settings {
  private static int counterweight;
  private static int projectileWeight;
  private static int altitude;
  private static double psi;
  private static Preferences p;
  
  public static void init() {
    p = Preferences.userRoot();
    counterweight = p.getInt("counterweight", 0);
    projectileWeight = p.getInt("projectileWeight", 0);
    psi = p.getDouble("psi", 0);
    altitude = p.getInt("altitude", 0);
  }
  
  public static int getCounterweight() {
    return counterweight;
  }
  
  public static double getPsi() {
    return psi;
  }
  
  public static int getProjectileWeight() {
    return projectileWeight;
  }
  
  public static int getAltitude() {
    return altitude;
  }
  
  public static void setCounterweight(int nuevo) {
    counterweight = nuevo;
    p.putInt("counterweight", counterweight);
  }
  
  public static void setProjectileWeight(int nuevo) {
    projectileWeight = nuevo;
    p.putInt("projectileWeight", projectileWeight);
  }
  
  public static void setAltitude(int nuevo) {
    altitude = nuevo;
    p.putInt("altitude", altitude);
  }
  
  public static void setPsi(double nuevo) {
    psi = nuevo;
    p.putDouble("psi", psi);
  }
}
