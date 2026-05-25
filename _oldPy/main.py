import os
import shutil

print("\n----------***----------")
path = os.getcwd() + '/Desktop/Calibration'
if os.path.exists(path):
    shutil.rmtree(path)
os.makedirs(path)

import main_4958
import main_4989

main_4958.main4958()
main_4989.main4989()
print("\n[Program Complete]\n")
print("----------***----------\n")
