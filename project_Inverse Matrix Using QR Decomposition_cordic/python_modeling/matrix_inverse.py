# import numpy as np
#
# def cordic_inverse_3x3(matrix):
#     # Placeholder for the actual CORDIC implementation
#     # This function should be replaced with the actual CORDIC algorithm
#     return np.linalg.inv(matrix)
#
# # Example 3x3 matrix
# matrix = np.array([[4, 7, 2],
#                    [3, 6, 1],
#                    [2, 5, 3]])
#
# # Compute the inverse using the placeholder function
# inverse_matrix = cordic_inverse_3x3(matrix)
#
# print("Original Matrix:")
# print(matrix)
# print("\nInverse Matrix:")
# print(inverse_matrix)
import matplotlib.pyplot as plt
import matplotlib.patches as patches

# Function to create a block diagram for the given SystemVerilog logic
def create_block_diagram():
    fig, ax = plt.subplots(figsize=(12, 8))

    # Add blocks for states
    states = [
        "IDLE", "phase1_1_in", "phase1_1_out",
        "phase1_2_in", "phase1_2_out", "phase1_3_in", "phase1_3_out",
        "phase2_1_in", "phase2_1_out", "phase2_2_in", "phase2_2_out", "phase2_3_in", "phase2_3_out",
        "phase3_1_in", "phase3_1_out", "phase3_2_in", "phase3_2_out",
        "multiply"
    ]

    # Coordinates for placing the blocks
    y_positions = [i * -1.5 for i in range(len(states))]

    # Draw state blocks
    for i, state in enumerate(states):
        ax.add_patch(patches.Rectangle((0, y_positions[i]), 2, 1, edgecolor='black', facecolor='lightblue'))
        ax.text(1, y_positions[i] + 0.5, state, fontsize=12, ha='center', va='center')

    # Draw arrows for transitions
    transitions = [
        ("IDLE", "phase1_1_in"), ("phase1_1_in", "phase1_1_out"),
        ("phase1_1_out", "phase1_2_in"), ("phase1_2_in", "phase1_2_out"),
        ("phase1_2_out", "phase1_3_in"), ("phase1_3_in", "phase1_3_out"),
        ("phase1_3_out", "phase2_1_in"), ("phase2_1_in", "phase2_1_out"),
        ("phase2_1_out", "phase2_2_in"), ("phase2_2_in", "phase2_2_out"),
        ("phase2_2_out", "phase2_3_in"), ("phase2_3_in", "phase2_3_out"),
        ("phase2_3_out", "phase3_1_in"), ("phase3_1_in", "phase3_1_out"),
        ("phase3_1_out", "phase3_2_in"), ("phase3_2_in", "phase3_2_out"),
        ("phase3_2_out", "multiply"), ("multiply", "IDLE")
    ]

    # Draw arrows based on transitions
    for start_state, end_state in transitions:
        start_y = y_positions[states.index(start_state)]
        end_y = y_positions[states.index(end_state)]
        ax.annotate("", xy=(1.5, end_y + 0.5), xytext=(1, start_y + 0.5),
                    arrowprops=dict(arrowstyle="->", lw=1.5))

    # Set the limits and remove axes
    ax.set_xlim(-1, 3)
    ax.set_ylim(-len(states) * 1.5 - 1, 1)
    ax.axis('off')

    plt.title("Block Diagram of State Machine", fontsize=16)
    plt.show()

create_block_diagram()
