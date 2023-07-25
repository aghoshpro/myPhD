import cv2

video = cv2.VideoCapture(0) #Webcam ID 0 or 1

# Parameters for tuning
detectionThresholdValue = 0.6 #0.6 means, detection accuracy 60%, if the model detects a PEN with equal or more than 50% accuracy then it will show the output

# Video Output Ratio
video.set(3, 1280)
video.set(4, 720)

# Importing list of categories from the coco.names
categories=[]
categoryFilename = 'cocoLARGE.names'

with open(categoryFilename, 'rt') as f:
    categories = f.read().rstrip('\n').split('\n') # read the file f and strip ans split the name based on new line (\n)

print(categories)

# configs and weights
configPath = 'ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt'
weightsPath = 'frozen_inference_graph.pb'

# configs and weights (2) much slower
# configPath = 'yolov3.cfg'
# weightsPath = 'yolov3.weights'

# Deep Neural Network (DNN) Model development
model_01 = cv2.dnn_DetectionModel(weightsPath, configPath) #from openCV, few parameters can be changed from documentation

# Creating blob from the frames of the Video
model_01.setInputSize(320, 320)  # input size that SSD models generally expect in almost all frameworks. It is the same for TensorFlow as well.
model_01.setInputScale(1.0/ 127.5) # openCV docs
model_01.setInputMean((127.5, 127.5, 127.5)) # means for 3 different channels where highest is 255
model_01.setInputSwapRB(True) 

# The fun part - Detection starts here
while True: 
    success, img = video.read()
    categoryIDs, confidence, bbox = model_01.detect(img, confThreshold=detectionThresholdValue) # list of three parameters
    print(categoryIDs, bbox) # [1] [[ 60  40 373 461]], here 1 means name at index 1 (person) in the coco.LARGEnames
    
    if len(categoryIDs)!= 0: 
        for catID, confi, box in zip(categoryIDs.flatten(), confidence.flatten(), bbox): #he zip() function returns a zip object contains multiple lists or tuples. flatten
            cv2.rectangle(img, box, color=(0,255,0), thickness = 3)
            cv2.putText(img, "{} {}".format(categories[catID].upper(),"({:.2f}%)".format(confidence[0]*100.0)),(box[0]+10,box[1]+30), cv2.FONT_HERSHEY_COMPLEX, 1, (0,255,0), 2) # green bbox

    cv2.imshow("Output", img)
    cv2.waitKey(1)







