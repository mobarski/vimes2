
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

def test_comments():
    text = """
        11 (22 33) 44 55 ; 66 77
        88 (xxx 99 zzz) 22 (;) 33 44
    """
    pcode = asm.compile(text, {})
    assert pcode == [11, 44, 55, 88, 22, 33, 44]

def test_comments2():
    text = """
        11 (22 33) 44 55 # 66 77
        88 (xxx 99 zzz) 22 (#) 33 44
        321 -- 123 432
    """
    pcode = asm.compile(text, {})
    assert pcode == [11, 44, 55, 88, 22, 33, 44, 321]

def test_kv():
    text = """
        aa=11 22 bb=33 44 cc=55
        bb aa cc
    """
    pcode = asm.compile(text, {})
    assert pcode == [22, 44, 33, 11, 55]

def test_kv2():
    text = """
        store=sta load=lda
        store 9 load 8 load 7 store 6
    """
    pcode = asm.compile(text, {'lda':11, 'sta':22})
    assert pcode == [22,9, 11,8, 11,7, 22,6]


def test_get_opcodes():
    text = open('../c/mk7c.h').read()
    opcodes = asm.get_opcodes_from_text(text)
    print(opcodes)

def test_kv_multi():
    text = """
        x=5
        s=x
        push-s=inc,s,spa,s
        lit 55 push-s
        lit 66 push-s
    """
    pcode = asm.compile(text, {'lit':1,'inc':11, 'spa':22})
    assert pcode == [1,55,11,5,22,5,1,66,11,5,22,5]


def test_kv_empty():
    text = """
        [= ]= ,= |=
        [ 11 ] , 22 , 33 | 44 55 | 66 [ 77 ] 88
    """
    pcode = asm.compile(text, {})
    assert pcode == [11,22,33,44,55,66,77,88]

def test_local_labels():
    text = """
        111
        aaa: 222
            .xxx: 333
        bbb: 444
            .xxx: 555
        end:
    """
    pcode,labels = asm.compile(text, {}, with_labels=True)
    assert(labels['aaa']==1)
    assert(labels['aaa.xxx']==2)
    assert(labels['bbb']==3)
    assert(labels['bbb.xxx']==4)
    assert(labels['end']==5)
    assert pcode == [111, 222, 333, 444, 555]
