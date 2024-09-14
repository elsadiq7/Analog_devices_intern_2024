# Import necessary libraries
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter, freqz
from convert_bin import write_to_file


def plot(x_axis, y_axis, title, x_str, y_str):
    """
    Plots a graph of the given x and y axes with appropriate labels, titles, and grid lines.

    Parameters:
    x_axis (array-like): Data for the x-axis.
    y_axis (array-like): Data for the y-axis.
    title (str): Title of the plot.
    x_str (str): Label for the x-axis.
    y_str (str): Label for the y-axis.

    Returns:
    None
    """
    # Create a figure and a set of subplots
    fig, axt = plt.subplots(1, 1, figsize=(20, 6))  # Adjust figsize as needed

    # Set font properties
    plt.rcParams.update({'font.size': 14, 'font.family': 'Times New Roman'})

    # Plot data on the first subplot (Time Domain)
    axt.plot(x_axis, y_axis, linewidth=2)  # Increased line width for better visibility
    axt.set_title(f"{title}", weight="bold")
    axt.set_xlabel(f"{x_str}", weight="bold")
    axt.set_ylabel(f"{y_str}", weight="bold")
    axt.grid()  # Enable grid for better visualization
    plt.savefig(f"images/{title}.png", bbox_inches='tight')
    # Show the plot
    plt.show()


# Coefficients for the FIR filter
coefficients = [1, 0.5, 0.25, 0.125]

# Get the frequency response based on the z-transform of the FIR filter
w, h = freqz(b=coefficients)

# Plotting the frequency response of the filter in dB
plot(w, 20 * np.log10(np.abs(h)), "Digital filter frequency response (FIR)", "Amplitude [dB]", "Frequency [rad/sample]")
N = 600
T = 1.0 / (10 ** 8)
# Generate a simple signal composed of multiple sine and cosine components
t = np.linspace(0, N * T, N)  # Time axis
w = 10 ** 6  # Base frequency
xn = np.sin(2 * np.pi * w * t) + np.cos(2 * np.pi * 10 * w * t) + np.sin(2 * np.pi * 20 * w * t) ** 2 + np.sin(
    2 * np.pi * 100 * w * t) ** 3

# Filter the signal using the FIR filter
xn_filtered = lfilter(coefficients, 1, xn)

# Plot the original signal in the time domain
plot(t, xn, "Original function in time domain", "Amplitude", "Time")

# Plot the filtered signal in the time domain
plot(t, xn_filtered, "Filtered function in time domain", "Amplitude", "Time")

###################################
in_error, op_error = write_to_file("in_op.txt", xn, xn_filtered, places_int=5, places_float=15, mode="w")

print("#" * 90)
# End of program output
print(f"Maximum input error: {max(in_error):.3f}%, Minimum input error: {min(in_error):.3f}%")
print(f"Minimum output error: {min(op_error):.3f}%, Maximum output error: {max(op_error):.3f}%")
print("Finished")
