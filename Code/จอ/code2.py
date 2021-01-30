
import serial
ser = serial.Serial('/dev/ttyACM0', 4800)

#m_rgb((245,244,191)),font="none 40 normal")
#d#ataPm10.pack(side = LEFT)

#valPm10unit = StringVar()
#valPm10unit.set('')
#unitPm10 = Label(pm10Frame, textvariable = valPm10unit,width="7", fg="green",bg=_from_rgb((245,244,191)),font="none 40 normal")
#unitPm10.pack(side = LEFT)

# ****************************************
#emtry2 = Frame(root)
#emtry2.pack()
#emtry2label = Label(emtry2, text="",width="1",height="2", fg="green",bg=_from_rgb((245,244,191)),font="none 50 normal")
#emtry2label.pack( side = BOTTOM)


# ****************************************
#tempFrame = Frame(root)
#tempFrame.pack(side = BOTTOM)
#Temp = StringVar()
#Temp.set('')
#Templabel = Label(tempFrame, textvariable = Temp, width="20", height="8", fg="green",bg=_from_rgb((245,244,191)),font="none 25 normal")
#Templabel.pack(side = LEFT)
#Templabel = Label(tempFrame, text = "", width="20", height="8", fg="green",bg=_from_rgb((245,244,191)),font="none 25 normal")
#Templabel.pack(side = LEFT)
#Humi = StringVar()
#Humi.set('')
#Humilabel = Label(tempFrame, textvariable = Humi, width="20", height="8", fg="green",bg=_from_rgb((245,244,191)),font="none 25 normal")
#Humilabel.pack(side = LEFT)

while 1:
#	now = datetime.datetime.now()
#	date = now.strftime("%d-%m-%Y")#
#	time = now.strftime("%H:%M:%S")
#	txtTime.set(time)
#	txtDate.set(date)
	
#	if keyboard.is_pressed('q'):
#		root.quit()
	if(ser.in_waiting > 0):
		line = ser.readline()
#			sensor = line.split()
#			pm25_1 = int(sensor[0])
#			pm10_1 = int(sensor[1])
#			pm25_2 = int(sensor[2])
#			pm25_3 = int(sensor[3])
#			temp = float(sensor[4])
		print(line)
