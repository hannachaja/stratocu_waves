import numpy as np
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

class AtmosphericProfiles:
    def __init__(self):
        # Constants
        self.g = 9.81  # m/s^2
        self.Rd = 287.0  # J/kg/K
        self.Rv = 461.5  # J/kg/K
        self.cp = 1004.0  # J/kg/K
        self.L = 2.5e6   # J/kg
        
        # Reference profile setup
        self.z = np.linspace(0, 30000, 301)  # Height in meters
        self.setup_reference_profile()
        
    def setup_reference_profile(self):
        """Create a tropical reference profile"""
        # Surface conditions
        T0 = 300.0  # K
        p0 = 101325.0  # Pa
        RH0 = 0.8  # Surface relative humidity
        
        # Initialize arrays
        self.p = np.zeros_like(self.z)
        self.T = np.zeros_like(self.z)
        self.q = np.zeros_like(self.z)
        
        # Simple tropical temperature profile
        # Troposphere (constant lapse rate to tropopause)
        gamma = 6.5/1000.0  # K/m
        tropopause_height = 16000  # m
        
        for i, z in enumerate(self.z):
            if z <= tropopause_height:
                self.T[i] = T0 - gamma * z
            else:
                # Stratosphere (isothermal)
                self.T[i] = T0 - gamma * tropopause_height
        
        # Hydrostatic pressure
        self.p[0] = p0
        for i in range(1, len(self.z)):
            dz = self.z[i] - self.z[i-1]
            Tbar = 0.5 * (self.T[i] + self.T[i-1])
            self.p[i] = self.p[i-1] * np.exp(-self.g * dz / (self.Rd * Tbar))
        
        # Specific humidity (decreasing with height)
        self.q = RH0 * self.saturation_mixing_ratio(self.T, self.p) * np.exp(-self.z/7000)
        
        # Calculate moist static energy
        self.h = self.moist_static_energy(self.z, self.T, self.q)
    
    def saturation_vapor_pressure(self, T):
        """Bolton's formula for saturation vapor pressure"""
        return 611.2 * np.exp(17.67 * (T - 273.15) / (T - 29.65))
    
    def saturation_mixing_ratio(self, T, p):
        """Calculate saturation mixing ratio"""
        es = self.saturation_vapor_pressure(T)
        return 0.622 * es / (p - es)
    
    def moist_static_energy(self, z, T, q):
        """Calculate moist static energy"""
        return self.cp * T + self.g * z + self.L * q
    
    def generate_wave_profile(self, wavelength, amplitude, node_at_8km=True):
        """
        Generate a gravity wave profile with specified wavelength and amplitude
        node_at_8km: If True, puts node at 8km; if False, puts antinode at 8km
        """
        # Calculate phase shift to get node or antinode at 8km
        phase_shift = np.pi/2 if node_at_8km else 0
        z_8km = 8000
        
        # Vertical displacement
        dz = amplitude * np.sin(2*np.pi/wavelength * (self.z - z_8km) + phase_shift)
        
        # Interpolate conserved variables to new positions
        z_displaced = self.z - dz
        h_interp = interp1d(self.z, self.h, bounds_error=False, fill_value="extrapolate")
        q_interp = interp1d(self.z, self.q, bounds_error=False, fill_value="extrapolate")
        
        # Get displaced values
        h_new = h_interp(z_displaced)
        q_new = q_interp(z_displaced)
        
        # Solve for temperature (simplified)
        T_new = (h_new - self.g * self.z - self.L * q_new) / self.cp
        
        return T_new, q_new
    
    def plot_profiles(self, wavelengths=[5000, 10000], amplitude=500, node_at_8km=True):
        """Plot reference and wave profiles"""
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 8))
        
        # Plot reference profile
        ax1.plot(self.T, self.z/1000, 'k-', label='Reference')
        ax2.plot(self.q*1000, self.z/1000, 'k-', label='Reference')
        
        # Plot wave profiles
        colors = plt.cm.rainbow(np.linspace(0, 1, len(wavelengths)))
        for wavelength, color in zip(wavelengths, colors):
            T_wave, q_wave = self.generate_wave_profile(wavelength, amplitude, node_at_8km)
            label = f'λ={wavelength/1000:.1f}km'
            ax1.plot(T_wave, self.z/1000, '--', color=color, label=label)
            ax2.plot(q_wave*1000, self.z/1000, '--', color=color, label=label)
        
        ax1.set_xlabel('Temperature (K)')
        ax1.set_ylabel('Height (km)')
        ax1.grid(True)
        ax1.legend()
        
        ax2.set_xlabel('Specific Humidity (g/kg)')
        ax2.set_ylabel('Height (km)')
        ax2.grid(True)
        ax2.legend()
        
        plt.tight_layout()
        plt.show()

# Example usage
profiles = AtmosphericProfiles()
profiles.plot_profiles(wavelengths=[5000, 10000, 15000], amplitude=500, node_at_8km=True)
