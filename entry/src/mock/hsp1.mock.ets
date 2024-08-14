/*
 * 获取斐波那契数组中，第参数的值
 * */
export function getFibonacciNum(n: number): number {
  if (n <= 1) {
    return n;
  }
  return getFibonacciNum(n - 2) + getFibonacciNum(n - 1);
}

/*
 * 获取所有项之和小于参数的斐波那契数组
 * @param TotalCount { number }, 大于等于数组项之和的数字
 * */
export function getFibonacciArrBySum(TotalCount: number) {
  let sum = 0;
  let index = 0;
  let fibonacciNum = 0
  const arr: number[] = [];

  while (sum < TotalCount) {
    fibonacciNum = getFibonacciNum(index);
    arr.push(fibonacciNum);
    sum += fibonacciNum;
    index++;
  }

  return arr;
}