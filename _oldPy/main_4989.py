import os
import csv


def main4989():
    # ----------read---------- #
    
    folder_path = "./Desktop/"
    files = os.listdir(folder_path)
    yy = []
    flag = False
    for file in files:
        if file.endswith("Type4989A.csv"):
            flag = True
            print(file)
            with open(os.path.join(folder_path, file), "r") as f:
                content = csv.reader(f)
                for row in content:
                    yy.append(row)
    if not flag:
        return
    
    # ----------split---------- #
    
    axis = yy[6][9:94]
    for u in range(len(yy)):
        for i in range(len(yy)):
            if len(yy[i]) == 0:
                yy.pop(i)
                break
            if len(yy[i][0]) != 6:
                yy.pop(i)
                break
            if not yy[i][0].isdigit():
                yy.pop(i)
                break
    for i in range(len(yy)):
        value = yy[i][9:94]
        locals()[yy[i][8].replace(' ', '')] = [axis, value]
    
    # ----------save---------- #
    
    for n in range(len(yy)):
        filepath = os.getcwd() + '/Desktop/Calibration/' + yy[n][8].replace(' ', '') + '.txt'
        with open(filepath, 'w', newline='') as txtFile:
            for i in range(len(locals()[yy[n][8].replace(' ', '')])):
                for j in range(len(locals()[yy[n][8].replace(' ', '')][i])):
                    txtFile.write((locals()[yy[n][8].replace(' ', '')])[i][j] + '\t')
                txtFile.write('\n')
