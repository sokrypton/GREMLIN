#include <math.h>
#include "mex.h"

/***
 * Original Version by Mark Schmidt (LLM2_pseudoC.c) modified by
 * Hetu Kamisetty. 
 *
 ***/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    /* variables */
    char param;
    int i, s, s1, s2, n, e, n1, n2, nInstances, nNodes, nStates, nEdges,
            *edges, *y, y1, y2;
    double *yr, *g1, *g2, *logPot, *z, *pseudoNLL, *w1, *w2, *nodeBel;
    
    /* input */
    param = *(mxChar*)mxGetData(prhs[0]);
    y = (int*)mxGetPr(prhs[1]);
    yr = mxGetPr(prhs[2]);
    g1 = mxGetPr(prhs[3]);
    g2 = mxGetPr(prhs[4]);
    edges = (int*)mxGetPr(prhs[5]);
    w1 = mxGetPr(prhs[6]);
    w2 = mxGetPr(prhs[7]);
    
    /* compute sizes */
    nInstances = mxGetDimensions(prhs[1])[0];
    nNodes = mxGetDimensions(prhs[6])[0];
    nStates = mxGetDimensions(prhs[6])[1]+1;
    nEdges = mxGetDimensions(prhs[5])[0];
    
    /* allocate memory */
    logPot = mxCalloc(nStates*nNodes, sizeof(double));
    z = mxCalloc(nNodes, sizeof(double));
    nodeBel = mxCalloc(nStates*nNodes, sizeof(double));
    
    /* output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, 0);
    pseudoNLL = mxGetPr(plhs[0]);
    *pseudoNLL = 0;
    
    /*printf("computed sizes: %d %d %d %d\n",nStates,nNodes,nEdges2,nEdges3);*/
    
    for(n=0;n < nNodes;n++) {
      for(i=0;i < nInstances;i++) {
        for(s=0;s < nStates-1;s++) {
          logPot[s+nStates*n] = w1[n+nNodes*s];
        }
        logPot[nStates-1+nStates*n] = 0;
        y1 = y[i + nInstances*n];

        for(n2 = 0; n2 < n ;n2++) {
          y2 = y[i + nInstances*n2];
          e=(nEdges-((nNodes-n2)*((nNodes-n2)-1))/2+(n-n2)-1);
          for(s=0; s<nStates; s++) {
            logPot[s+nStates*n] += w2[y2+nStates*(s+nStates*e)];
          }
        }
        for(n2 = n+1; n2 < nNodes ;n2++) {
          y2 = y[i + nInstances*n2];
          e=(nEdges-((nNodes-n)*((nNodes-n)-1))/2+(n2-n)-1);
          for(s=0; s<nStates; s++) {
            logPot[s+nStates*n] += w2[s+nStates*(y2+nStates*e)];
          }
        }


        z[n] = 0;
        for(s = 0; s < nStates; s++) {
          z[n] += exp(logPot[s+nStates*n]);
        }
        *pseudoNLL -= yr[i]*logPot[y[i+nInstances*n] + nStates*n];
        *pseudoNLL += yr[i]*log(z[n]);

        /*printf("pseudoNLL = %f\n",*pseudoNLL);*/

        for(s = 0; s < nStates; s++) {
          nodeBel[s + nStates*n] = exp(logPot[s + nStates*n] - log(z[n]));
        }

        y1 = y[i + nInstances*n];

        if(y1 < nStates-1)
          g1[n + nNodes*y1] -= yr[i]*1;

        for(s=0; s < nStates-1; s++)
          g1[n + nNodes*s] += yr[i]*nodeBel[s+nStates*n];
        for(n1 = 0; n1 < n;n1++) {
          e=(nEdges-((nNodes-n1)*((nNodes-n1)-1))/2+(n-n1)-1);
          y1 = y[i + nInstances*n1];
          y2 = y[i + nInstances*n];

          g2[y1+nStates*(y2+nStates*e)] -= yr[i];
          for(s=0;s<nStates;s++) {
            g2[y1+nStates*(s+nStates*e)] += yr[i]*nodeBel[s+nStates*n];
          }
        }
        for(n2 = n+1; n2 < nNodes;n2++) {
          e=(nEdges-((nNodes-n)*((nNodes-n)-1))/2+(n2-n)-1);
          y1 = y[i + nInstances*n];
          y2 = y[i + nInstances*n2];

          g2[y1+nStates*(y2+nStates*e)] -= yr[i];
          for(s=0;s<nStates;s++) {
            g2[s+nStates*(y2+nStates*e)] += yr[i]*nodeBel[s+nStates*n];
          }
        }
      }
    }
    /*
    for(n=0;n < nNodes;n++) {
      for(s=0; s<nStates; s++) {
        mexPrintf("g1 %d %d %f\n", n, s, g1[n+nNodes*s]);
      }
    }
    for(e=0;e < nEdges;e++) {
      n1 = edges[e];
      n2 = edges[e+nEdges];
      for(s1=0; s1<nStates; s1++) {
        for(s2=0; s2<nStates; s2++) {
          mexPrintf("g2 %d %d %f\n", e, s, g2[s1+nStates*(s2+nStates*e)]);
        }
      }
    }
    mexPrintf("pseudoNll in single loop %f\n", *pseudoNLL);
    */
    mxFree(logPot);
    mxFree(z);
    mxFree(nodeBel);
}
