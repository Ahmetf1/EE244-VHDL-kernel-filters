The work is co-conducted by Oğuzhan İzgi [@prfessor](https://www.github.com/prfessor)
# VHDL-kernel-filters
VHDL implementation of 3x3 kernel filters

## Results

### Original Image
![alt text](https://github.com/ahmetf1/VHDL-kernel-filters/blob/main/results/original.jpg?raw=true)

### Processed Image
![alt text](https://github.com/ahmetf1/VHDL-kernel-filters/blob/main/results/processed.jpg?raw=true)


## Design

### VGA Driver
First of all, it is supposed to display an image through VGA display. In order to do this, the raw data of the image, which consists of intensity values of each pixel respectively is needed. It is desired to process images rapidly, so images are processed in grayscale, that is to say, red, green and blue intensity values are same. In this way, much less hardware power is required in the project.

In order to display the image, signals called horizontal and vertical synchronization signals are
needed. The synchronization signal consists of two regularly occurring negative pulses. The negative pulses on the horizontal synchronization signal indicate the beginning and end of a line, guaranteeing that the monitor accurately displays the pixels within the visible screen area boundaries. To generate these signals accurately, counters called h_count and v_count are used. The value h_count controls horizontal signal, v_count controls vertical signal.

### Dual Port Rom
To store images in the device, block memory fields of SPARTAN6 is utilized. To initialize a kernel at least two pixels were required. By using dual port ROM, two pixels can be obtained from the memory at the same clock cycle. In order to create dual port ROM components, core generator application of Xilinx is used. Memory fields are initialized with .coe files.

Contents of the .coe files are created by using a python script that just simply resizing the given image to monitor resolution and listing the pixel intensity of each pixel starting from the most top left pixel to the most down right pixel.

### Image Processor
After obtaining each pixel values in an appropriate order, a kernel filter is used to process image. To filter image with kernel filter, convolution operation is used. This process is shown below:
Figure 4 - Sample Kernel Filter
1. Place the kernel filter on top of a pixel in the image.
2. Multiply each value in the kernel with the corresponding pixel value in the image.
3. Sum up the multiplied values.
4. Replace the original pixel value
with the summed value obtained in the previous step.
5. Slide the kernel to the next pixel in the image and repeat steps 2-4.
6. Continue this process until the kernel has covered the entire image.

By convolving the kernel filter on the image, we obtain a new image called convolved or filtered image. The resulting image highlights features depending on the type of kernel. For example, a kernel designed for edge detection can emphasize the edges of an image, while a blurred kernel will smooth the image by averaging nearby pixel values.

After filtering the image, it is displayed on the screen.
