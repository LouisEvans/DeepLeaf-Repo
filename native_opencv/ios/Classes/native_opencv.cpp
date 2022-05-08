#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

//ACKNOWLEDGEMENTS:
//https://medium.com/flutter-community/integrating-c-library-in-a-flutter-app-using-dart-ffi-38a15e16bc14

extern "C" {
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    void process_image(char* inputImagePath, char* outputImagePath) {

        // Open image
        Mat image;
        image= cv::imread(inputImagePath);

        Mat image2 = image.clone();

        // Define bounding rectangle
        cv::Rect rectangle(10,10,image.cols-20,image.rows-20);

        cv::Mat result; // Segmentation result (4 possible values)
        cv::Mat bgModel,fgModel; // The models (internally used)

        // GrabCut segmentation
        cv::grabCut(image,    // input image
                    result,   // segmentation result
                    rectangle,// rectangle containing foreground
                    bgModel,fgModel, // models
                    5,        // number of iterations
                    cv::GC_INIT_WITH_RECT); // use rectangle
        cout << "oks pa dito" <<endl;
        // Get the pixels marked as likely foreground
        cv::compare(result,cv::GC_PR_FGD,result,cv::CMP_EQ);
        // Generate output image
        cv::Mat foreground(image.size(),CV_8UC3,cv::Scalar(0,0,0));
        // cv::Mat background(image.size(),CV_8UC3,cv::Scalar(255,255,255));
        image.copyTo(foreground,result); // bg pixels not copied

        imwrite(outputImagePath,foreground);
    }
}