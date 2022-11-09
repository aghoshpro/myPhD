## WASP Object Detection Part 2
**WASP_AS_M1_Umeå1**: Arka Ghosh,  Divya Baura,  Joannes Vermant, Julian Alfredo Mendez and Sabine Houy


### Install ```OpenCV```

First ```pip3 install --upgrade pip``` then  ```pip3 install opencv-python```

We used ```opencv-python``` 4.6.0.66, which requires ```numpy``` 1.17.3 or later, but we used 1.22 or later.
The requiremenets are included in ```requirements.txt```.



### There are two codes

1. ```objectDetectionVideo.py```: The first one can take any video as an input and detect objects in the output video.

2. ```objectDetectionWebCam.py```: This code can access webcam and detect the objects

This particular project detects objects using the mobileNet SSD method. Therefore before proceeding, three files are a pre-requisite —---------
* ‘coco.names’
* ‘ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt’ (configurations)
* ‘frozen_inference_graph.pb’ (weights)


OpenCV needs a configuration file to import object detection models from TensorFlow. It's based on a text version of the same serialized graph in protocol buffers format (protobuf).


### **Reading Materials**

[COCO (Common Objects In Context)](https://cocodataset.org/#home): is a set of challenging, high quality datasets for computer vision, mostly state-of-the-art neural networks. This name is also used to name a format used by those datasets.

[Object Detection using SSD Mobilenet and Tensorflow Object Detection](https://medium.com/@techmayank2000/object-detection-using-ssd-mobilenetv2-using-tensorflow-api-can-detect-any-single-class-from-31a31bbd0691)

[FAQ on Object Detection Using SSD mobilenet](https://madhumitamenon.medium.com/faq-on-object-detection-using-ssd-mobilenet-b8bf31924601)
************************************************************************************************************************************************************************

### Dataset
[Coco Names](https://github.com/nightrome/cocostuff/blob/master/labels.md): Contains lables of 182 objects that can be detected on the video stream.


### Model Used
[**MobileNet-SSD v3**](https://github.com/opencv/opencv/wiki/TensorFlow-Object-Detection-API): SSD (Single Shot MultiBox Detector) is a popular algorithm in object detection which is a single convolution network that learns to predict bounding box locations and classify these locations in one pass. Hence, SSD can be trained end-to-end. The SSD network consists of base architecture (MobileNet in this case) followed by several convolution layers.

By using SSD, we only need to take one single shot to detect multiple objects within the image, while regional proposal network (RPN) based approaches such as R-CNN series that need two shots, one for generating region proposals, one for detecting the object of each proposal. Thus, SSD is much faster compared with two-shot RPN-based approaches

Significance of ‘**ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt**’ 
This file is a pre-trained Tensorflow model and has already been trained on the COCO dataset.

Significance of ‘**frozen_inference_graph.pb**’?
Freezing is the process to identify and save all of required things(graph, weights etc) in a single file that you can easily use. Frozen graphs are commonly used for inference in TensorFlow and are stepping stones for inference for other frameworks

### Output


#### Output 01 (at 55% detection accuracy)
https://user-images.githubusercontent.com/71174892/196672496-30e54277-dfee-425e-add1-73aedeaefccd.mp4


#### Output 02 (at 60% detection accuracy)
https://user-images.githubusercontent.com/71174892/196671666-5cba1fa3-e1b7-4f75-83d9-a55d4e4aabe0.mp4

#### WebCam Output (at 60% detection accuracy)

https://drive.google.com/file/d/1eVs8WdziXL-AQ7JvFME4I5RuqYis_R8o/view?usp=sharing
