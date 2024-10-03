import numpy as np
from convert_bin import  *
def convert_bin(matrix_numpy):
    matrix=[["a","b","c"],["a","b","c"],["a","b","c"]]
    for i in range(3):
        for j in range(3):
            matrix[i][j]=float_bin(matrix_numpy[i][j],8,24)
    return matrix


# Define a 3x3 matrix
A = np.array([[1, 2,3],
              [2,1,1],
              [6,0,1]])
# Perform QR decomposition
Q, R = np.linalg.qr(A)

# Print the Q and R matrices
print("Matrix A:")
print(A)
print(convert_bin(A))

print("\nMatrix Q (Orthogonal matrix):")
print(Q)
print(convert_bin(Q))
print("\nMatrix R (Upper triangular matrix):")
print(R)
print(convert_bin(R))
# Check if A = Q * R
A_reconstructed = np.dot(Q, R)
print("\nReconstructed Matrix (Q * R):")
print(A_reconstructed)

# Calculate the inverse of the matrix using QR decomposition
# Inverse of A = inverse(R) * transpose(Q)
R_inv = np.linalg.inv(R)
Q_T = np.transpose(Q)
A_inv_qr = np.dot(R_inv, Q_T)

print("Q_inv_binary")
print(convert_bin(Q_T))
print("R_inv_binary")
print(convert_bin(R_inv))
# Print the inverse calculated through QR decomposition
print("\nInverse of Matrix A using QR decomposition:")
print(A_inv_qr)
# Calculate the inverse of the matrix directly using NumPy's function
A_inv = np.linalg.inv(A)

# Print the direct inverse of the matrix
print("\nDirect Inverse of Matrix A using NumPy:")
print(A_inv)
print(convert_bin(A_inv))

# Verify that both methods give the same result
print("\nVerification: Difference between QR-based inverse and direct inverse:")
print(A_inv - A_inv_qr)

# Verify by multiplying the original matrix by the inverse to check if it returns an identity matrix
identity_matrix_qr = np.dot(A, A_inv_qr)
identity_matrix_direct = np.dot(A, A_inv)

print("\nVerification (A * A_inv_qr) - should be close to identity matrix:")
print(identity_matrix_qr)

print("\nVerification (A * A_inv_direct) - should be close to identity matrix:")
print(identity_matrix_direct)

print(convert_two_complement2decimal("11111001100110001100110011011010",8,24))
