def recursiveParse(original, new, stack, found):
    if "S" not in new and new == original:
        # found = True
        return (True, stack)
    else:
        index = 0
        for char in new:
            if char == "S":
                break
            index += 1
        checkString = ""
        checkString += new[:index]
        if original.startswith(checkString + "a"):
            checkString += "aSbS"
            checkString += new[index+1:len(new)]
            stack.append(1)
            res = recursiveParse(original, checkString, stack, found)
            if res[0] == False:
                stack.pop()
                index = 0
                for char in new:
                    if char == "S":
                        break
                    index += 1
                checkString = ""
                checkString += new[:index]
            else:
                return True, stack
            # elif found:
            #     return True, stack
        if original.startswith(checkString + "b"):
            checkString += "bSaS"
            checkString += new[index+1:len(new)]
            stack.append(2)
            res = recursiveParse(original, checkString, stack, found)
            if res[0] == False:
                stack.pop()
                index = 0
                for char in new:
                    if char == "S":
                        break
                    index += 1
                checkString = ""
                checkString += new[:index]
            else:
                return True, stack
        if (checkString == original and new[len(new) - 1] == "S") or original.startswith(
                checkString + new[index + 1]):
            checkString += new[index + 1: len(new)]
            stack.append(3)
            res = recursiveParse(original, checkString, stack, found)
            if res[0] == False:
                stack.pop()
                index = 0
                for char in new:
                    if char == "S":
                        break
                    index += 1
                checkString = ""
                checkString += new[:index]
            else:
                return True, stack
            # elif found:
            #     return True, stack
        return False, stack

def dfparse(IN):
    valids = ['a', 'b']
    countA = 0
    countB = 0
    stack = []
    for char in IN:
        if char not in valids:
            print(False, stack)
            return
        elif char == "a":
            countA += 1
        else:
            countB += 1
    if (countA + countB) % 2 != 0 or countA != countB:
        print(False, stack)
    else:
        b = False
        print(recursiveParse(IN, "S", stack, b))


def main():
    IN = input()
    print(dfparse(IN))

if __name__ == "__main__":
    main()