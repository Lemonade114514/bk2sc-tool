import csv
import os


def main4958():
    # ----------read---------- #

    folder_path = "./Desktop/"
    files = os.listdir(folder_path)
    yy = []
    flag = False
    for file in files:
        if file.endswith("Type4958A.csv"):
            flag = True
            print(file)
            with open(os.path.join(folder_path, file), "r") as f:
                content = csv.reader(f)
                for row in content:
                    yy.append(row)
    if not flag:
        return

    # ----------split---------- #

    axis = yy[2][7:85]
    for u in range(len(yy)):
        for i in range(len(yy)):
            if len(yy[i]) == 0:
                yy.pop(i)
                break
            if len(yy[i][0]) != 7:
                yy.pop(i)
                break
            if not yy[i][0].isdigit():
                yy.pop(i)
                break
    for i in range(len(yy)):
        value = yy[i][7:85]
        locals()[yy[i][6].replace(' ', '')] = [axis, value]

    # ----------save---------- #

    for n in range(len(yy)):
        filepath = os.getcwd() + '/Desktop/Calibration/' + yy[n][6].replace(' ', '') + '.txt'
        with open(filepath, 'w', newline='') as txtFile:
            for i in range(len(locals()[yy[n][6].replace(' ', '')])):
                for j in range(len(locals()[yy[n][6].replace(' ', '')][i])):
                    txtFile.write((locals()[yy[n][6].replace(' ', '')])[i][j] + '\t')
                txtFile.write('\n')
