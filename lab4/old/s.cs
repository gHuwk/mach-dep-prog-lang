public static void DrawEllipseBresenham(Bitmap workBitmap, Color workColor, Point center, int radiusX, int radiusY)
    {
        int x = 0;
        int y = radiusY;
        long aSqr = radiusX * radiusX;
        long bSqr = y * y;

        long aSqrTwice = aSqr * 2;
        long bSqrTwice = bSqr * 2;

        //error = b^2 * (x+1)^2 + a^2 * (y-1)^2-a^2 * b^2=
        long error = bSqr - aSqrTwice * radiusY + aSqr;

        long dx = 0;
        long dy = aSqrTwice * y;

        DrawSymmetric(workBitmap, workColor, center, x, y);

        while (y > 0)
        {
            if (error < 0)
            {
                if (2 * error + dy - aSqr > 0)
                {
                    DiagonalStep(ref x, ref y, ref error, ref aSqr, ref aSqrTwice, ref bSqr, ref bSqrTwice, ref dx, ref dy);
                }
                else
                {
                    HorizontalStep(ref x, ref y, ref error, ref bSqr, ref bSqrTwice, ref dx);
                }
            }
            else if (error > 0)
            {
                if (2 * error - dx - bSqr > 0)
                {
                    VerticalStep(ref x, ref y, ref error, ref aSqr, ref aSqrTwice, ref dy);
                }
                else
                {
                    DiagonalStep(ref x, ref y, ref error, ref aSqr, ref aSqrTwice, ref bSqr, ref bSqrTwice, ref dx, ref dy);
                }
            }
            else
            {
                DiagonalStep(ref x, ref y, ref error, ref aSqr, ref aSqrTwice, ref bSqr, ref bSqrTwice, ref dx, ref dy);
            }

            DrawSymmetric(workBitmap, workColor, center, x, y);
        }
    }

private static void DiagonalStep(ref int x, ref int y, ref long error, ref long aSqr, ref long aSqrTwice, ref long bSqr, ref long bSqrTwice, ref long dx, ref long dy)
    {
        x++;
        y--;
        dx += bSqrTwice;
        dy -= aSqrTwice;
        error += dx - dy + aSqr + bSqr;
    }

private static void HorizontalStep(ref int x, ref int y, ref long error, ref long bSqr, ref long bSqrTwice, ref long dx)
    {
        x++;
        dx += bSqrTwice;
        error += dx + bSqr;
    }

private static void VerticalStep(ref int x, ref int y, ref long error, ref long aSqr, ref long aSqrTwice, ref long dy)
    {
        y--;
        dy -= aSqrTwice;
        error += -dy + aSqr;
    }