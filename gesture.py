import cv2
import numpy as np
import math
import requests as req
cap = cv2.VideoCapture(0)



def nothing(x):
    pass

# Create to variables, current and previous. Compare before action...Makes a function run once in the while loop
present = 1
current = 0

# Dynamic HSV Color Selection
cv2.namedWindow("Tracking")
cv2.createTrackbar("LH", "Tracking", 1, 255, nothing)
cv2.createTrackbar("LS", "Tracking", 1, 255, nothing)
cv2.createTrackbar("LV", "Tracking", 1, 255, nothing)
cv2.createTrackbar("UH", "Tracking", 20, 255, nothing)
cv2.createTrackbar("US", "Tracking", 255, 255, nothing)
cv2.createTrackbar("UV", "Tracking", 255, 255, nothing)
     
while(1):
        
    try:  
          
          
        ret, frame = cap.read()
        frame=cv2.flip(frame,1)
        kernel = np.ones((3,3),np.uint8)
        
        #define region of interest
        roi=frame[100:300, 100:300]
        
        
        cv2.rectangle(frame,(100,100),(300,300),(0,255,0),0)    
        hsv = cv2.cvtColor(roi, cv2.COLOR_BGR2HSV)
        
        
         
    # define range of skin color in HSV using trackers
        l_h = cv2.getTrackbarPos("LH", "Tracking")
        l_s = cv2.getTrackbarPos("LS", "Tracking")
        l_v = cv2.getTrackbarPos("LV", "Tracking")

        u_h = cv2.getTrackbarPos("UH", "Tracking")
        u_s = cv2.getTrackbarPos("US", "Tracking")
        u_v = cv2.getTrackbarPos("UV", "Tracking")
        lower_skin = np.array([l_h,l_s,l_v], dtype=np.uint8)
        upper_skin = np.array([u_h,u_s,u_v], dtype=np.uint8)
        
     #a mask for the skin color
        mask = cv2.inRange(hsv, lower_skin, upper_skin)
        mask = cv2.dilate(mask,kernel,iterations = 4)
        mask = cv2.GaussianBlur(mask,(5,5),100) 

        contours,hierarchy= cv2.findContours(mask,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
        cnt = max(contours, key = lambda x: cv2.contourArea(x))
        epsilon = 0.0005*cv2.arcLength(cnt,True)
        approx= cv2.approxPolyDP(cnt,epsilon,True)
        hull = cv2.convexHull(cnt)
        areahull = cv2.contourArea(hull)
        areacnt = cv2.contourArea(cnt)
        arearatio=((areahull-areacnt)/areacnt)*100
        hull = cv2.convexHull(approx, returnPoints=False)
        defects = cv2.convexityDefects(approx, hull)
        
        detection_dot=0
        
    #code for finding no. of detections due to fingers
        for i in range(defects.shape[0]):
            s,e,f,d = defects[i,0]
            start = tuple(approx[s][0])
            end = tuple(approx[e][0])
            far = tuple(approx[f][0])
            pt= (100,180)
            
            
            a = math.sqrt((end[0] - start[0])**2 + (end[1] - start[1])**2)
            b = math.sqrt((far[0] - start[0])**2 + (far[1] - start[1])**2)
            c = math.sqrt((end[0] - far[0])**2 + (end[1] - far[1])**2)
            s = (a+b+c)/2
            ar = math.sqrt(s*(s-a)*(s-b)*(s-c))
            
            d=(2*ar)/a
            
            # cosine rule for angle
            angle = math.acos((b**2 + c**2 - a**2)/(2*b*c)) * 57
            
        
            # ignore angles > 90 and ignore points very close to convex hull(they generally come due to noise)
            if angle <= 90 and d>30:
                detection_dot += 1
                cv2.circle(roi, far, 3, [255,0,0], -1)
            
            #draw lines around hand
            cv2.line(roi,start, end, [0,255,0], 2)
            
            
        detection_dot+=1
        
        #print corresponding gestures which are in their ranges
        text = cv2.FONT_HERSHEY_SIMPLEX
        if detection_dot==1:
            if areacnt<2000:
                cv2.putText(frame,'Put hand in the box',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
            else:
                if arearatio<12:
                    cv2.putText(frame,'0',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
                elif arearatio<17.5:
                    cv2.putText(frame,'Best of luck',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
                   
                else:
                    cv2.putText(frame,'1',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
                    
        elif detection_dot==2:
            cv2.putText(frame,'2',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
            if (current != present):
                print('2 happened once')
                current = 1
            
        elif detection_dot==3:
         
              if arearatio<27:
                    cv2.putText(frame,'3',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
                    if(current == present):
                        print('3 happened once')
                        current = 0
              else:
                    cv2.putText(frame,'Peace',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
                    
        elif detection_dot==4:
            cv2.putText(frame,'4',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
            
        elif detection_dot==5:
            cv2.putText(frame,'5',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
            
        elif detection_dot==6:
            cv2.putText(frame,'reposition',(0,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
            
        else :
            cv2.putText(frame,'reposition',(10,50), text, 2, (0,0,255), 3, cv2.LINE_AA)
            
        cv2.imshow('mask',mask)
        cv2.imshow('frame',frame)
    except:
        pass
        
    
    k = cv2.waitKey(5) & 0xFF
    if k == 27:
        break
    
cv2.destroyAllWindows()
cap.release()    