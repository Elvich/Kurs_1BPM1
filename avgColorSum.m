function Sum = avgColorSum( S_gray, x_c, y_c, h, e )
det_zone = imcrop(S_gray,[x_c y_c, h, e]);
[I,J] = size(det_zone);
Sum = 0.0;
    for k = 1:I 
        for m = 1:J
            pixel = det_zone(k,m);
            Sum = Sum + double(pixel);
        end
    end
    Sum = Sum/(h*e)
end

