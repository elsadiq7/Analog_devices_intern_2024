import numpy as np


class CORDIC:
    def __init__(self, iterations):
        """
        Initialize the CORDIC class.

        Parameters:
        iterations (int): The number of iterations to perform.
        """
        self.iterations = iterations
        self.tan_array = self._generate_tan_array()  # Precompute tangent values
        self.scaling_factor = self.generate_K()  # Calculate the scaling factor
        self.inverse_x = 1
        self.inverse_y = 1
        self.change = 0

    def _generate_tan_array(self):
        """
        Generate the tangent values for CORDIC rotations.

        Returns:
        numpy.ndarray: Precomputed tangent values.
        """
        return np.array([np.arctan(2 ** -i) for i in range(self.iterations)])

    def _initialize_arrays(self, x_in, y_in, sqrt, theta):
        """
        Initialize the arrays used in the CORDIC algorithm.

        Parameters:
        x_in (float): Initial x value.
        y_in (float): Initial y value.
        sqrt (bool): Indicates whether to compute square root or not.
        theta (float): Initial angle in degrees if not computing square root.

        Returns:
        tuple: x_array, y_array, z_array, segma
        """
        x_array = np.zeros(self.iterations)
        y_array = np.zeros(self.iterations)
        z_array = np.zeros(self.iterations)
        segma = np.zeros(self.iterations)

        self.inverse_x = 1
        self.inverse_y = 1
        self.change = 0
        # Set initial values
        x_array[0] = abs(x_in)
        y_array[0] = abs(y_in)

        if sqrt:
            z_array[0] = 0
            segma[0] = 1 if y_array[0] < 0 else -1
        else:
            if theta < 0:
                theta = theta + np.pi
            if theta > (2 * np.pi):
                theta = theta % np.pi
            if theta > (np.pi / 2) and theta < (np.pi):
                theta = theta - np.pi
                self.inverse_y = -1
                self.change = 1
            elif theta >= (np.pi) and theta < (3 * np.pi * .5):
                theta = theta - np.pi
                self.inverse_x = -1
                self.inverse_y = -1
            elif theta > (np.pi * 1.5):
                theta = theta - (np.pi) * 2
            z_array[0] = theta
            segma[0] = 1 if z_array[0] >= 0 else -1

        return x_array, y_array, z_array, segma

    def generate_sqrt_sin_cos(self, x_in=1, y_in=0, sqrt=False, theta=0):
        """
        Generate sine, cosine, or magnitude and angle using the CORDIC algorithm.

        Parameters:
        x_in (float): Initial x value.
        y_in (float): Initial y value.
        sqrt (bool): Indicates whether to compute square root or not.
        theta (float): Initial angle in degrees if not computing square root.

        Returns:
        tuple: (cos_val, sin_val) or (mag, angle) depending on the value of sqrt.
        """
        # Initialize arrays
        x_array, y_array, z_array, segma = self._initialize_arrays(x_in, y_in, sqrt, theta)

        # Perform CORDIC iterations
        for j in range(self.iterations - 1):
            factor = 2 ** (-j)
            # Update x, y, and z values based on the current iteration
            x_new = x_array[j] - segma[j] * factor * y_array[j]
            y_new = y_array[j] + segma[j] * factor * x_array[j]
            z_new = z_array[j] - segma[j] * self.tan_array[j]

            # Update arrays
            x_array[j + 1] = x_new
            y_array[j + 1] = y_new
            z_array[j + 1] = z_new

            # Update the sign for the next iteration
            if sqrt:
                segma[j + 1] = 1 if y_new < 0 else -1
            else:
                segma[j + 1] = 1 if z_new >= 0 else -1

        # Return cosine and sine values or magnitude and angle based on sqrt
        if not sqrt:
            cos_val = x_array[self.iterations - 1] * self.scaling_factor * self.inverse_x
            sin_val = y_array[self.iterations - 1] * self.scaling_factor * self.inverse_y
            if self.change == 1:
                cos_val, sin_val = sin_val, cos_val
            return cos_val, sin_val
        else:
            mag = x_array[self.iterations - 1] * self.scaling_factor
            angle = z_array[self.iterations - 1]
            return mag, angle

    def generate_K(self):
        """
        Calculates the scaling factor for the CORDIC algorithm.

        Parameters:
        iterations (int): Number of iterations to compute the scaling factor.

        Returns:
        float: The inverse of the computed scaling factor.
        """
        k = np.float64(1)
        for j in range(self.iterations):
            k *= (1 + 2 ** (-2 * j)) ** 0.5
        return 1 / k


def test_cordic_with_difference(iterations=15):
    cordic = CORDIC(iterations)

    total_diff_cos = 0
    total_diff_sin = 0

    num_angle_tests = 0
    sin_array = []
    cos_array = []

    print("-" * 90)
    yin = 0
    xin = 1
    initial_theta = np.arctan(yin / xin)
    print(xin, yin)
    test_angles_deg = np.arange(0, np.pi / 2.0, .05)
    print(
        f"{'Angle (deg)':>12} | {'CORDIC Cos':>10} | {'NumPy Cos':>10} | {'Diff Cos':>10} | {'CORDIC Sin':>10} | {'NumPy Sin':>10} | {'Diff Sin':>10}")
    for theta in test_angles_deg:
        cos_val, sin_val = cordic.generate_sqrt_sin_cos(x_in=xin, y_in=yin, sqrt=False, theta=theta)
        sin_array.append(sin_val)
        cos_array.append(cos_val)
        expected_cos = np.cos(theta + initial_theta)
        expected_sin = np.sin(theta + initial_theta)
        diff_cos = abs(cos_val - expected_cos)
        diff_sin = abs(sin_val - expected_sin)

        total_diff_cos += diff_cos
        total_diff_sin += diff_sin
        num_angle_tests += 1

        print(
            f"{theta:12} | {cos_val:10.6f} | {expected_cos:10.6f} | {diff_cos:10.6f} | {sin_val:10.6f} | {expected_sin:10.6f} | {diff_sin:10.6f}")

    avg_diff_cos = total_diff_cos / num_angle_tests if num_angle_tests > 0 else 0
    avg_diff_sin = total_diff_sin / num_angle_tests if num_angle_tests > 0 else 0

    print("\nAverage Errors:")
    print(f"Average Cosine Error: {avg_diff_cos:.6f}")
    print(f"Average Sine Error: {avg_diff_sin:.6f}")
    return sin_array, cos_array, test_angles_deg


def test_cordic_vectors(iterations=15):
    print("\n{'Vectoring Test':>12}")
    print(f"{'X':>5} | {'Y':>5} | {'CORDIC Sqrt':>12} | {'NumPy Sqrt':>12} | {'Diff Sqrt':>12}")
    print("-" * 50)
    cordic = CORDIC(iterations)
    total_diff_sqrt = 0
    total_angle_diff = 0
    num_vectoring_tests = 0
    sqrt_cordic_array = []
    x = []
    y = []
    angle_array = []
    for i in range(1, 10):
        for j in range(1, 10):
            x.append(i)
            y.append(j)

            sqrt_cordic, angle = cordic.generate_sqrt_sin_cos(i, j, sqrt=True)
            angle_array.append(angle)

            sqrt_cordic_array.append(sqrt_cordic)
            sqrt_numpy = (i ** 2 + j ** 2) ** 0.5

            diff_sqrt = abs(sqrt_cordic - sqrt_numpy)
            angle_diff = abs(np.arctan(j / i) - angle)

            total_angle_diff += angle_diff
            total_diff_sqrt += diff_sqrt
            num_vectoring_tests += 1

            # print(f"{i:5} | {j:5} | {sqrt_cordic:12.6f} | {sqrt_numpy:12.6f} | {diff_sqrt:12.6f}")
    avg_diff_sqrt = total_diff_sqrt / num_vectoring_tests if num_vectoring_tests > 0 else 0
    avg_diff_angle = total_angle_diff / num_vectoring_tests if num_vectoring_tests > 0 else 0
    print(f"Average Square Root Error: {avg_diff_sqrt:.6f},Average Angle Root Error: {avg_diff_angle:.6f}")

    return x, y, sqrt_cordic_array, avg_diff_angle
