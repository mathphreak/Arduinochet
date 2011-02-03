// Equations from:
// www.algobeautytreb.com/trebmath35.pdf
// en.wikipedia.org/wiki/Gravity_of_Earth#Altitude
// en.wikipedia.org/wiki/Earth_radius

public abstract class Calculation {
  private static final int EARTH_MEAN_RADIUS = 3959 * 5280;
  
  private static double gravity(double altitude) {
    return 32.1740 * (EARTH_MEAN_RADIUS/(EARTH_MEAN_RADIUS+altitude));
  }
  
  public static double rangeEfficiency(double cwMass, double pMass, double initialVelocity, double angle, int altitude, double cwHeight) {
    double firstPart = pMass/cwMass;
    double numerator = ((Math.pow(initialVelocity, 2)) * Math.sin(angle)) * Math.cos(angle);
    double denominator = gravity(altitude) * cwHeight;
    return firstPart * (numerator / denominator);
  }
  
  public static double cwHeight(double hingeCWDistance, double psi) {
    return hingeCWDistance * (1 - Math.sin(psi));
  }
  
  /**
   *  Calculates the range of the trebuchet.
   *  @param cwMass the mass of the counterweight (in pounds) [unused]
   *  @param pMass the mass of the projectile (in pounds) [unused]
   *  @param hingeCWDistance the distance from the hinge to the counterweight (in feet) [unused]
   *  @param psi the distance from the hinge to the counterweight (in radians) [unused]
   *  @param initialVelocity the initial velocity of the projectile (in ft/s)
   *  @param angle the angle from horizontal of the projectile when it's fired (in radians)
   *  @param altitude the altitude of the current location (in feet)
   */
  public static double range(double cwMass, double pMass, double hingeCWDistance, double psi, double initialVelocity, double angle, int altitude) {
    double h = cwHeight(hingeCWDistance, psi);
    double optimal = 2 * (cwMass / pMass) * h;
    double efficiency = rangeEfficiency(cwMass, pMass, initialVelocity, angle, altitude, h);
    return optimal * efficiency;
  }
}
    
