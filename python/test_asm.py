
import asm

def test_opcodes():
    opcodes = {'ADD':1, 'OPR':1, 'RET':0, 'LIT':2}
    pcode = asm.compile("LIT 30  LIT 12  OPR ADD", opcodes)
    assert pcode == [2, 30, 2, 12, 1, 1]

def test_labels():
    text = """
        99 11 label1: 22 33 label2: 44
        ; this is a comment 77 88
        label1 label2 55 label2 label1 66
    """
    pcode = asm.compile(text, {})
    assert pcode == [99, 11, 22, 33, 44, 2, 4, 55, 4, 2, 66]
