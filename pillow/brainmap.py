import cv2
import scipy.io as sio
import math
import re
import collections
import os



class Connection:
	"""
		This class is for lines between electrodes. 
	"""
	def __init__(self, tailName, headName, channel_map, weights, colors = None):
		"""
			Initialization function for Connection class
			Input:	tailName ----> The name of the channel for the tail of the point
					headName ----> The name of the channel for the head of the point
					channel_map ----> a dictionary that has channel names for keys and image coordinates (x, y) tuples for values
					weights ----> A list containing the weights of all of the lines drawn between the two points
					colors(Optional) ----> A list of (b, g, r) tuples containing the colors of all of the lines drawn between the two points
		"""
		self.tail = channel_map[tailName]
		self.head = channel_map[headName]
		self.tailName = tailName
		self.headName = headName
		self.weights = weights
		self.colors = colors

	def __str__(self):
		"""	
			Prints tail name and head name.
		"""
		return "tail: "+self.tailName+"\nhead: "+self.headName+"\nweights: "+str(self.weights)



	def tailChannelNumber(self):
		"""
			Returns the integer value for the number on the channel name of the tail
		"""
		pattern = "[A-Z]*(\d)"
		match = re.search(pattern, self.tailName)

		return int(match.group(1))

	def headChannelNumber(self):
		"""
			Returns the integer value for the number on the channel name of the head
		"""
		pattern = "[A-Z]*(\d)"
		match = re.search(pattern, self.headName)

		return int(match.group(1))



def createConnections(channel_names, weights, channel_map, colors = None):
	"""
		Takes in a matrix of weights and channel names and returns a list of Connection objects
		Input:	channel_names ----> A length (n x 1) numpy array containing channel names
				weights ----> An (n x n x k) numpy array containing connection weights (floats). k is the number of different types of connections you have
				channel_map ----> A Dictionary with channel names as the keys and (x, y) tuples as the values
	"""
	connections = []
	#create pairs
	for (i, ival) in enumerate(list(channel_names)):
		for (j, jval) in enumerate(list(channel_names)):
			if(i != j):
				weightCol = [int(w*const) for w in list( [temp_w[i][j] for temp_w in weights])]
			else:
				weightCol = [0 for w in list( [temp_w[i][j] for temp_w in weights])]
			connection = Connection(ival.replace(" ", ""), jval.replace(" ", ""), channel_map, weightCol, colors)
			connections.append(connection)
	return connections


def rAway(number):
	return math.ceil(number) if number>0 else math.floor(number)
def displayConnections(img, connections):
	"""
		This function takes in a List of Connections and returns and image with the lines drawn that resemble those connections
		Input: 	img ----> The CV Mat
				connections ---->  A list of Connection objects
	"""
	for connection in connections:
		p = []
		count = 0
		for (index, weight) in enumerate(connection.weights):
			t1 = connection.tail
			t2 = connection.head
			if(weight != 0):
				if(count == 0):
					offset = 0
				elif(count == 1):
					offset = abs((connection.weights[0])+abs(connection.weights[1]))
				elif(count == 2):
					offset = -1*(abs((connection.weights[0])+abs(connection.weights[2])))
				else:
					offset = (-1)**(count+1)*(abs(p[count-2])+abs(connection.weights[index-2])+abs(connection.weights[index]))
				p.append(offset)


				x_diff = float(t2[0]-t1[0])
				y_diff = float(t1[1]-t2[1])
	
				t1 = (t1[0]+rAway((y_diff)*offset/(math.sqrt(x_diff**2+y_diff**2))), t1[1]+rAway((x_diff)*offset/(math.sqrt(x_diff**2+y_diff**2))))
				t2 = (t2[0]+rAway((y_diff)*offset/(math.sqrt(x_diff**2+y_diff**2))), t2[1]+rAway((x_diff)*offset/(math.sqrt(x_diff**2+y_diff**2))))

				if(weight>thresh):
					if(connection.colors != None):
						cv2.arrowedLine(img, t1, t2, connection.colors[index], weight*2, 8, 0, 0)
					else:
						cv2.arrowedLine(img, t1, t2, (0,0,255), weight*2, 8, 0, 0)
				count = count+1
	return img

def setNodeColors(img, channel_map, colors = None):
	"""
		This function adds circles to your image at all of the channels you specify with the colors that you specify
		Input:	img ----> The CV Mat
				channel_map ----> A Dictionary with channel names as the keys and (x, y) tuples as the values
				colors(optional) ----> A Dictionary with channel names as the keys and (b, g, r) tuples as the values
		Output: A CV Mat with the circles added
	"""
	if(colors != None):
		for name in channel_map.keys():
			cv2.circle(img, channel_map[name], 40, colors[name], -1, lineType=8, shift=0)
	else:
		for name in channel_map.keys():
			cv2.circle(img, channel_map[name], 40, (255, 255, 255), -1, lineType=8, shift=0)
	return img


def exportImage(img, filename):
	"""
		This function exports the matrix to an image in your current folder
		Input: 	img ----> The CV Mat
				filename ----> a string filename
	"""
	cv2.imwrite(filename, img)


def mainProcess(img, channel_map, channel_names, channel_weights, connection_colors = None, channel_colors = None, connections_mapping = None):
	"""
	This function runs all of the functions above to create an image and returns the image
	"""
	connections = createConnections(channel_names, channel_weights, channel_map, connection_colors)
	if(connections_mapping != None):
		connections = map(connections_mapping, connections)
	img = displayConnections(img, connections)
	img = setNodeColors(img, channel_map, channel_colors)
	return img



#Electrode labels
electrodes = {
	"LT1" :(1304, 2563),
	"LT2": (1528, 2564),
	"LT3": (1792, 2584),
	"LT4": (2034, 2628),
	"LT5": (2330, 2602),
	"LT6": (2621, 2630),
	"LT7": (2914, 2557),
	"LT8": (3169, 2492),
	"LT9": (3405, 2405),
	"LT10": (3616, 2371),
	"LT11": (1289, 2360),
	"LT12": (1500, 2368),
	"LT13": (1729, 2372),
	"LT14": (1993, 2382),
	"LT15": (2279, 2379),
	"LT16": (2573, 2373),
	"LT17": (2865, 2329),
	"LT18": (3150, 2243),
	"LT19": (3404, 2174),
	"LT20": (3623, 2117),
	"LT21": (1260, 2314),
	"LT22": (1484, 2266),
	"LT23": (1692, 2213),
	"LT24": (1957, 2161),
	"LT25": (2220, 2127),
	"LT26": (2516, 2101),
	"LT27": (2807, 2041),
	"LT28": (3087, 1964),
	"LT29": (3345, 1907),
	"LT30": (3550, 1876),
	"LT31": (1231, 2036),
	"LT32": (1417, 1996),
	"LT33": (1672, 1944),
	"LT34": (1929, 1883),
	"LT35": (2174, 1841),
	"LT36":(2449, 1808),
	"LT37":(2721, 1753),
	"LT38":(2997, 1702),
	"LT39":(3271, 1640),
	"LT40": (3514, 1596), 
	"LO1": (3881, 1611),
	"LO2": (3742, 1663),
	"LO3": (3907, 1837),
	"LO4":(3789, 1914),
	"LO5":(3971, 2053),
	"LO6":(3852, 2161),
	"LO7":(3973, 2301),
	"LO8": (3854, 2388),
	"LF1":(597, 1425),
	"LF2":(794, 1419),
	"LF3":(1042, 1417),
	"LF4":(1284, 1425),
	"LF5":(1545, 1390),
	"LF6":(1828, 1393),
	"LF7":(2106, 1382),
	"LF8":(2376, 1356),
	"LF9":(2665, 1342),
	"LF10":(2942, 1354),
	"LF11":(671, 1178),
	"LF12":(832, 1169),
	"LF13":(1089, 1177),
	"LF14":(1298, 1168),
	"LF15":(1560, 1134),
	"LF16":(1826, 1124),
	"LF17":(2111, 1112),
	"LF18":(2381, 1091),
	"LF19":(2650, 1068),
	"LF20":(2921, 1080),
	"OP1": (4991, 1960),
	"OP2": (4995, 2294),
	"OP3": (5077, 2509),
	"OP4": (5191, 2630),
	"SO1": (5197, 869),
	"SO2": (5314, 1040),
	"SO3": (5438, 1213),
	"SO4": (5563, 1393),
	"SO5": (5670, 1589),
	"SO6": (5814, 1925),
	"SO7": (5871, 2241),
	"SO8": (5989, 2511),
	"SO9": (6072, 2718),
	"SO10": (6183, 2902),
	"PST1": (5434, 924),
	"PST2": (5554, 1074),
	"PST3": (5685, 1230),
	"PST4": (5820, 1473),
	"PST5": (5960, 1741),
	"PST6": (6082, 2007),
	"PST7": (6215, 2302),
	"PST8": (6329, 2528),
	"MST2": (6612, 2108),
	"MST3": (6728, 2400),
	"MST4": (6870, 2649),
	"MST5": (6994, 2845),
	"MST6": (7119, 3022),
	"AST2": (7752, 2106),
	"AST3": (7725, 2368),
	"AST4": (7634, 2642),
	"AST5": (7573, 3005),
	"AST6": (7547, 3143),
	"TP1": (7615, 2561),
	"TP2": (7905, 2424),
	"TP3": (8175, 2356),
	"TP4": (8378, 2417),
	"TP5": (8445, 2515),
	"TP6": (8420, 2617),
	"OF1": (8483, 1903),
	"OF2": (8375, 2140),
	"OF3": (8299, 2303),
	"OF4": (8257, 2413),
	"OF5": (8700, 1912),
	"OF6": (8585, 2077),
	"OF7": (8507, 2277),
	"OF8": (8466, 2424),
	"OF9": (8924, 1812),
	"OF10": (8805, 1994),
	"OF11": (8729, 2198),
	"OF12": (8646, 2459),
	"OF13": (8991, 1942),
	"OF14": (8900, 2142),
	"OF15": (8822, 2309),
	"OF16": (8785, 2407)
}

#--------------------------------------------
#Demo Image Code




#Initial image that things will be placed on (Image has to be 9999x3371)
image = cv2.imread('LBI.png', cv2.IMREAD_COLOR)

#The nxn matrix of values that represent the connection strength
mat = sio.loadmat('final.mat')

#The nx1 matrix of channel names
mat2 = sio.loadmat('channels_occ.mat')
weights = mat['final']
channel_names = mat2['channels']

#This is the threshold for width sizes that appear on the screen.
thresh = 3

#This is the multiplier for your weight values.
const = 12

# Weights of different colors have to be in different weight matricies
imgArr = []
for fetch_index in range(70):
	image = cv2.imread('LBI.png', cv2.IMREAD_COLOR)
	print("processing frame "+str(fetch_index))
	#Use the map_connections function to change weights after the are already connections. Here I am using it to select which connections are which colors.
	def map_connections(connection):
		if(connection.head<connection.tail):
			pass
		return connection

	sendingArr = []
	for i in range(len(weights)):
		tempArr = []
		for j in range(len(weights[0])):
			tempArr.append(weights[i][j][fetch_index])
		sendingArr.append(tempArr)


	ch_weights = [sendingArr]
	ch_colors = [(0,0,255)]
	electrode_colors = collections.defaultdict(lambda: (255, 255, 255))
	imgArr.append(mainProcess(image, electrodes, channel_names, ch_weights, channel_colors = electrode_colors,connection_colors = ch_colors, connections_mapping = map_connections))




#---------------------------------
# Demo Video Code

# CREATING VIDEO FROM imgArr!!
output = "testme2"
r_imgArray = []
height, width, channels = imgArr[0].shape
# Determine the width and height from the first image
for kimage in imgArr:
	r_image = cv2.resize(kimage, (int(1/2*width), int(1/2*height)), interpolation = cv2.INTER_CUBIC)
	r_imgArray.append(r_image)



height, width, channels = r_imgArray[0].shape
cv2.imshow('video',r_imgArray[0])


# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'mp4v') # Be sure to use lower case
out = cv2.VideoWriter(output, fourcc, 20.0, (width, height))
print("Creating video")
count = 0
for my_image in r_imgArray:


    count = count+1
    print("Rendering frame "+str(count))

    out.write(my_image) # Write out frame to video
    cv2.imshow('video',my_image)
    if (cv2.waitKey(1) & 0xFF) == ord('q'): # Hit `q` to exit
        break

# Release everything if job is finished
out.release()
cv2.destroyAllWindows()

print("The output video is {}".format(output))



































