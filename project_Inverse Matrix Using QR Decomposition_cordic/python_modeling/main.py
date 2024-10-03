import numpy as np

from python_modeling.convert_bin import *
from python_modeling.cordic_modeling import *
if __name__ == '__main__':


    print(float_bin( (1**2+.25)**.5, 8, 24))
    print(float_bin(np.arctan(.5/1), 8, 24))



    expected_sin,expected_cos,test_angles_deg=test_cordic_with_difference()
    x,y,sqrt,_=test_cordic_vectors()
    ### writing to file
    print("writing to files ")
    e1,e2,e3=write_to_file("../test_files/in_out_cordic_rot.txt", test_angles_deg, expected_cos, expected_sin, places_int=4, places_float=28, mode="w")
    print(f"in_degree_error={e1},cos_error={e2},sin_error={e3}")

    x_e1, y_e2, sqrt_e3 = write_to_file("../test_files/in_out_cordic_vector.txt", x, y, sqrt, places_int=4,
                                        places_float=28, mode="w")
    print(f"x_error={e1},y_error={e2},sqrt_error={e3}")
    print(np.random.rand())

