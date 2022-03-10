#include <stdio.h>
#include <helper_functions.h>
#include <helper_cuda.h>
#include <vector>


class Conv{

	private:
	static byte* d_data;
	static int capa;

	Conv(){}
	Conv(Conv const&);
	void operator =(Conv const&);


	public:

	Conv(Conv const&)            = delete;
	void operator=(Conv const&)  = delete;

	static Conv getInstance(){
		capa=0;
		static Conv instance;

		return instance;
	}

	static void Convolution(byte* data, int kernel, int chan){
	
	}
};

int main()
{
    int *a, *b, *c, *golden;
	int *d_a, *d_b, *d_c;
	int size = N * sizeof( int );

	cudaMalloc( (void **) &d_a, size );
	cudaMalloc( (void **) &d_b, size );
	cudaMalloc( (void **) &d_c, size );
	

	a = (int *)malloc( size );
	b = (int *)malloc( size );
	c = (int *)malloc( size );
	golden = (int *)malloc(size);

	for( int i = 0; i < N; i++ )
	{
		a[i] = b[i] = i;
		golden[i] = a[i] + b[i];
		c[i] = 0;
	}


	cudaMemcpy( d_a, a, size, cudaMemcpyHostToDevice );
	cudaMemcpy( d_b, b, size, cudaMemcpyHostToDevice );

	vector_add <<< (N + (THREADS_PER_BLOCK-1)) / THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( d_a, d_b, d_c );

	cudaMemcpy( c, d_c, size, cudaMemcpyDeviceToHost );

	bool pass = true;
	for (int i = 0; i < N; i++) {
		if (golden[i] != c[i])
			pass = false;
	}
	
	if (pass)
		printf("PASS\n");
	else
		printf("FAIL\n");

	printf("print your name and id\n");

	free(a);
	free(b);
	free(c);
	free(golden);
	cudaFree( d_a );
	cudaFree( d_b );
	cudaFree( d_c );
	
	return 0;
} 
