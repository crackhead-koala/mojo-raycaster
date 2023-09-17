import memory
from memory.unsafe import Pointer

# from python import Python
# from python.object import PythonObject


struct Array[T: AnyType, capacity: Int]:
    var _data: Pointer[T]

    fn __init__(inout self, *values: VariadicList[T]) raises:
        self._data = Pointer[T].alloc(capacity)
        memory.memset_zero(self._data, capacity)

        if len(values) != capacity:
            raise Error('Cannot fill array to `capacity` with provided `values`.')

        for idx in range(len(values)):
            self._data.store(idx, values[idx])

    fn __getitem__(self, idx: Int) raises -> T:
        if idx >= capacity or -idx >= capacity:
            raise Error('Array index out of range.')
        if idx < 0:
            return self._data.load(capacity - idx)
        return self._data.load(idx)


struct Map[size: Int]:
    let layout: Array[Int, size * size]

    fn __init__(inout self, layout: Array[Int, size * size]):
        self.layout = layout


fn print_map[size: Int](map: Map[size]) raises:
    for i in range(size):
        for j in range(size):
            if map.layout[size * i + j] == 1:
                print_no_newline('■')
            elif map.layout[size * i + j] == 1:
                print_no_newline(' ')
            else:
                raise Error('Unexpected map layout value.')
        put_new_line()


fn main() raises:
    var m: Map = Map[8](Array[Int, 64](
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 1, 0, 1,
        1, 0, 0, 0, 0, 1, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1
    ))
    print_map(m)
