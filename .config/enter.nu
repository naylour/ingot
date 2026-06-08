let commit_hash = (^git log --format="%h" -1 | str trim)
let commit_msg = (^git log --format="%s" -1 | str trim)
let branch = (^git branch --show-current | str trim)

let tools = (do { ^mise ls } | complete | get stdout
    | lines | skip 1
    | each { str trim | split row ' ' | first }
    | where { $in | is-not-empty }
    | uniq
    | each {|t|
        if ($t | str contains ":") {
            $t | split row ":" | last | split row "/" | last
        } else { $t }
    }
    | uniq)

print ""
print $"(ansi cyan_bold)⚙  ingot(ansi reset)  (ansi dark_gray)($branch)(ansi reset)"
print $"(ansi dark_gray)($commit_hash)(ansi reset)  ($commit_msg)"
print ""
print "tools:"
for row in ($tools | chunks 2) {
    let left = ($row | get 0? | default "" | fill -w 18 -a left)
    let right = ($row | get 1? | default "")
    print $"  (ansi dark_gray)·(ansi reset)  ($left)(ansi dark_gray)·(ansi reset)  ($right)"
}
print ""
